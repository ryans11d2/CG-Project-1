Shader "Game/Screen"
{
    Properties
    {
        _Color ("Colour", Color) = (1,1,1,1)//Background Colour Adjustment
        _MainTex ("Texture", 2D) = "white" {}//Background Texture
        _DecalTex ("Decal", 2D) = "white" {}//Decal Texture

		_ScaleX ("Scale X", Range(0, 10)) = 1//Decal Scale X
		_ScaleY ("Scale Y", Range(0, 10)) = 1//Decal Scale Y

		_PosX ("Pos X", Range(0, 1)) = 1//Maximum Range of Decal Texture (draw background texture when pixel x >) Left Cutoff
		_CutX ("Cut X", Range(0, 1)) = 0//Minimum Range of Decal Texture (draw background texture when pixel x <) Right Cutoff

		_PosY ("Pos Y", Range(0, 1)) = 1//Maximum Range of Decal Texture (draw background texture when pixel y >) Top Cutoff
		_CutY ("Cut Y", Range(0, 1)) = 0//Minimum Range of Decal Texture (draw background texture when pixel y <) Bottom Cutoff

		_OffX ("Off X", Range(-1, 1)) = 0//Decal X Offset
		_OffY ("Off Y", Range(-1, 1)) = 0//Decal Y Offset

		_Static ("Static Speed", Range(-100, 100)) = 0//Scroll Speed of Background Texture (Along Y Axis)

		_Active ("Toggle", Range(0, 1)) = 1

    }
    SubShader
    {
        Tags {"Queue" = "Geometry"}
		
        Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			uniform float4 _Color;
			sampler2D _MainTex;
			sampler2D _DecalTex;
			
			float _PosX;
			float _CutX;
			float _OffX;

			float _PosY;
			float _CutY;
			float _OffY;

			float _ScaleX;
			float _ScaleY;

			float _Static;

			float _Active;

			uniform float4 _LightColor0;


			struct vertexInput//vertexInput component
			{
				float4 vertex: POSITION;//Vertex position
				float3 normal: NORMAL;//Vertec normal
				float4 texcoord : TEXCOORD0;//Texture coordinates (pixel from texture to reference)
			};

			struct vertexOutput//vertexOutput component
			{
				float4 pos: SV_POSITION;//Vertex position
				float4 col: COLOR;//Vertex colour
				float4 normalDir : TEXCOORD1;
				float2 uv : TEXCOORD2;//Texture coordinates (pixel from texture for reference)
				float2 uvDecal : TEXCOORD3;//Decal texture coordinates (pixel from texture for decal to use)
				float2 scroll : TEXCOORD4;//Moving texture coordinates (pixel from texture for background to use)
			};

			vertexOutput vert(vertexInput v) 
			{
				vertexOutput o;//o has the pos and col col variables of vertexOutput
				//Calculate output o variables using input v information and return o

				float3 normalDirection = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
				float3 lightDirection;
				float atten = 1.0;
			
				lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				
				//Calculate diffuse reflection using normal and light direction gathered above
				float3 diffuseReflection = atten * _LightColor0.xyz * max(0.0, dot(normalDirection, lightDirection));
				
				//Calculate Ambient Light
				float3 lightFinal = diffuseReflection + UNITY_LIGHTMODEL_AMBIENT.xyz;//Add environmental light from unity (for ambient)

				o.col = float4(lightFinal * _Color.rgb, 1.0);//Set o color

				o.pos = UnityObjectToClipPos(v.vertex);//Set position of vertex

				o.uv = v.texcoord;//Get background texture uv

				//Offset background texture based on time
				_Static *= _Time;//Multiply background offset by the time
				o.scroll = v.texcoord;
				o.scroll.y += _Static;//Add offset to uv.y
				

				//Get decal uv and scale it using scale variables
				o.uvDecal.x = v.texcoord.x * (1 / _ScaleX);
				o.uvDecal.y = v.texcoord.y * (1 / _ScaleY);

				o.normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject));

				return o;//return vertex
			}

			float4 frag(vertexOutput i): COLOR//Get fragment color from vertex output
			{

				//Move decal draw region based on offset (so texture isn't cut off when moved)
				_PosX += _OffX;
				_CutX += _OffX;

				_PosY += _OffY;
				_CutY += _OffY;


				fixed4 col = tex2D(_MainTex, i.scroll);//Draw background texture

				//Replace pixels inside the draw region with the decal texture (pixels where uv.x > PosX)
				col = _PosX < i.uv.x ? col : tex2D(_DecalTex, i.uvDecal - float2(_OffX, _OffY)) * i.col;
				//Replace pixels outside the draw region with the background texture (pixels where uv.x < CutX)
				col = _CutX < i.uv.x ? col : tex2D(_MainTex, i.scroll);

				//Replace pixels outside the draw region with the background texture (pixels where PosY < uv.y < CutY)
				col = _CutY < i.uv.y ? col : tex2D(_MainTex, i.scroll);
				col = _PosY > i.uv.y ? col : tex2D(_MainTex, i.scroll);

				//Replace transparent decal pixels with background texture
				col = col.a > 0 ? col : tex2D(_MainTex, i.scroll);


				return col * _Active;//Set fragment colour
			}

			ENDCG
		}
		
    }
    FallBack "Diffuse"
}
