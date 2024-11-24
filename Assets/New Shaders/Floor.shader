Shader "Game/Floor"
{
	Properties
	{
		_Color ("Colour", Color) = (1, 0, 0, 1)//Main Colour
		_MainTex ("Texture", 2D) = "white" {}//Main Texture

		_BumpMap ("Bump Texture", 2D) = "bump" {}//Bump Map
        _Bump ("Bump Amount", Range(-1, 1)) = 1//Bump Multiplier

		_Active ("Active", Range(0, 1)) = 1//Texture Toggle

	}

	SubShader
	{

		Tags {"LightMode" = "ForwardBase"}
	
		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			uniform float4 _Color;
			sampler2D _MainTex;
			sampler2D _BumpMap;
			float _Bump;
			float _Active;

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
				float2 uv : TEXCOORD0;//Texture coordinates (pixel from texture to use)
				float4 normalDir : TEXCOORD1;
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
				float3 light_final = diffuseReflection;

				o.col = float4(light_final, 1.0);//Set o color

				o.pos = UnityObjectToClipPos(v.vertex);//Set position of vertex

				o.uv = v.texcoord;//Set uv position

				o.normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject));

				return o;//return vertex
			}

			float4 frag(vertexOutput i): COLOR//Get fragment color from vertex output
			{	
				
				//Reset normal based on normal map
				float3 normalDirection = i.normalDir;//Use predetermined normal direction
				normalDirection *= tex2D(_BumpMap, i.uv);//Add bump map normals
				normalDirection.y *= _Bump;
                float atten = 1.0;

                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);//Get light direction
                float3 diffuseReflection = atten * _LightColor0.xyz * max(0.0, dot(normalDirection, lightDirection));

				fixed4 col = float4(diffuseReflection, 1.0);


				col += tex2D(_MainTex, i.uv);//Set Texture
				col *= _Color * _Active;//Add colour, if toggled off set colour to black
				col = _Active == 1 ? col : _Color;//If texture is disabled, add colour

				return col;//Set fragment colour
			}

			ENDCG
		}

		
	}
}

