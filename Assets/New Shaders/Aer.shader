Shader "Custom/Aer"
{
	Properties
	{
		_Color ("Colour", Color) = (1, 0, 0, 1) // Default to red
		_Colaer ("Colaer", Color) = (0, 1, 0, 1)
		_SCALE("Scale", Range(-10, 10)) = 1
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
			uniform float4 _Colaer;

			uniform float4 _LightColor0;

			uniform float _SCALE;

			struct vertexInput
			{
				float4 vertex: POSITION;
				float3 normal: NORMAL;
			};


			struct vertexOutput
			{
				float4 pos: SV_POSITION;
				float4 col: COLOR;
			};

			vertexOutput vert(vertexInput v) 
			{
				vertexOutput o;
			
				float3 normalDirection = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
				float3 lightDirection;
				float atten = 1.0;
			
				lightDirection = normalize(_WorldSpaceLightPos0.xyz);

				float3 diffuseReflection;
				
				//float3 diffuseReflection = atten * _LightColor0.xyz * _Color.rgb * max(0.0, dot(normalDirection, lightDirection));
				//o.col = float4(diffuseReflection, 1.0);

				diffuseReflection = atten * _LightColor0.xyz * max(0.0, dot(normalDirection, lightDirection));
				float3 lightFinal = diffuseReflection + UNITY_LIGHTMODEL_AMBIENT.xyz;
				o.col = float4(lightFinal * _Color.rgb, 1.0);

				o.pos = UnityObjectToClipPos(v.vertex);// + float4(0.1, 0.1, 0.1, 0.1);

				o.col.r = o.pos.x / 10;
				o.col.g = o.pos.y / 10;
				o.col.b = o.pos.z / 10;

				return o;
			}

			float4 frag(vertexOutput i): COLOR
			{
				//Take the highest colour value comparing 2 different colours
				//i.col.r = i.col.r > _Colaer.r ? i.col.r : _Colaer.r;
				//i.col.g = i.col.g > _Colaer.g ? i.col.g : _Colaer.g;
				//i.col.b = i.col.b > _Colaer.b ? i.col.b : _Colaer.b;



				//i.col.r = i.col.b = i.col.g;//Set all colours to green value

				return  i.col;
			}

			ENDCG
		}

		Pass//Second Pass (Lambert)
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			uniform float4 _Color;
			int _Aer;

			uniform float4 _LightColor0;

			struct Input
			{
				float2 uv_MainTex;
			};

			struct vertexInput
			{
				float4 vertex: POSITION;
				float3 normal: NORMAL;
			};

			struct vertexOutput
			{
				float4 pos: SV_POSITION;
				float4 col: COLOR;
			};

			vertexOutput vert(vertexInput v) 
			{
				vertexOutput o;
			
				float3 normalDirection = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
				float3 lightDirection;
				float atten = 1.0;
			
				lightDirection = normalize(_WorldSpaceLightPos0.xyz);

				float3 diffuseReflection;
				
				if (_Aer == 1) {
					float3 diffuseReflection = atten * _LightColor0.xyz * _Color.rgb * max(0.0, dot(normalDirection, lightDirection));
					o.col = float4(diffuseReflection, 1.0);
				}
				else 
				{
					diffuseReflection = atten * _LightColor0.xyz * max(0.0, dot(normalDirection, lightDirection));
					float3 lightFinal = diffuseReflection + UNITY_LIGHTMODEL_AMBIENT.xyz;
					o.col = float4(lightFinal * _Color.rgb, 1.0);
				}

				

				o.pos = UnityObjectToClipPos(v.vertex);

				return o;
			}

			float4 frag(vertexOutput i): COLOR
			{
				return i.col;
			}

			ENDCG
		}

	}
}

