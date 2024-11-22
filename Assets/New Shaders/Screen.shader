Shader "Custom/Screen"
{
    Properties
    {
        _Color ("Colour", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
        _DecalTex ("Decal", 2D) = "white" {}

		_ScaleX ("Scale X", Range(0, 10)) = 1
		_ScaleY ("Scale Y", Range(0, 10)) = 1

		_PosX ("Pos X", Range(0, 1)) = 1
		_CutX ("Cut X", Range(0, 1)) = 0

		_PosY ("Pos Y", Range(0, 1)) = 1
		_CutY ("Cut Y", Range(0, 1)) = 0

		_OffX ("Off X", Range(-1, 1)) = 0
		_OffY ("Off Y", Range(-1, 1)) = 0

		_MoveY ("Move Y", float) = 0

    }
    SubShader
    {
        Tags {"Queue" = "Geometry"}

		
        CGPROGRAM

        #pragma surface surf Lambert

        fixed4 _Color;
        sampler2D _MainTex;
        sampler2D _DecalTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 a = tex2D(_MainTex, IN.uv_MainTex);// * _Color;
            fixed4 b = tex2D(_DecalTex, IN.uv_MainTex);// * _Color;

			o.Albedo = a.rgb;
            o.Albedo = b.a == 0 ? o.Albedo : b.rgb;
        }
        ENDCG
		
		
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

			//float _MoveY;

			uniform float4 _LightColor0;


			struct vertexInput//vertexInput component
			{
				float4 vertex: POSITION;//Vertex position
				float3 normal: NORMAL;//Vertec normal
				float4 texcoord : TEXCOORD0;//Texture coordinates (pixel from texture to use)
			};

			struct vertexOutput//vertexOutput component
			{
				float4 pos: SV_POSITION;//Vertex position
				float4 col: COLOR;//Vertex colour
				float4 posWorld : TEXCOORD0;
				float4 normalDir : TEXCOORD1;
				float2 uv : TEXCOORD2;//Texture coordinates (pixel from texture to use)
				float2 uvDecal : TEXCOORD3;
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
				o.posWorld = mul(unity_ObjectToWorld, v.vertex);

				o.uv = v.texcoord;
				o.uvDecal.x = v.texcoord.x * (1 / _ScaleX);
				o.uvDecal.y = v.texcoord.y * (1 / _ScaleY);

				o.normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject));

				return o;//return vertex
			}

			float4 frag(vertexOutput i): COLOR//Get fragment color from vertex output
			{
				/*
				//Move Decal Automaticaly
				_MoveY *= _Time;

				float steps = 1024;
				float speed = 100;
				float timer = (int(_MoveY * speed / 2) % steps) - (steps / 2);

				float _UpY = (int(_MoveY * speed) % steps);
				_UpY *= 0.001;
				_UpY -= 0.55;

				float _DownY = (int(_MoveY * speed) % steps);
				_DownY *= 0.001;
				_DownY += 0.55;

				_OffY = 0.9 - (_DownY * 1);
				_OffY = timer > 0 ? _OffY : _UpY;

				//_OffY = sin(_MoveY / 10) < 0 ? _OffY : (1.2 - _DownY) * 2;
				*/

				_PosX += _OffX;
				_CutX += _OffX;

				_PosY += _OffY;
				_CutY += _OffY;

				fixed4 col = tex2D(_MainTex, i.uv);
				col = _PosX < i.uv.x ? col : tex2D(_DecalTex, i.uvDecal - float2(_OffX, _OffY)) * i.col;
				col = _CutX < i.uv.x ? col : tex2D(_MainTex, i.uv);

				col = _CutY < i.uv.y ? col : tex2D(_MainTex, i.uv);
				col = _PosY > i.uv.y ? col : tex2D(_MainTex, i.uv);

				col = col.a > 0 ? col : tex2D(_MainTex, i.uv);

				col.r = 0;


				return col;//Set fragment color to vertex colour
			}

			ENDCG
		}
		
    }
    FallBack "Diffuse"
}
