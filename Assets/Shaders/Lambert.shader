Shader "Custom/Lambaert"
{
	Properties
	{
		_Color ("Colour", Color) = (1, 0, 0, 1) // Default to red
		_Aer ("<1 Ambient, 1 Diffuse", Range(1, 0)) = 1
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
			int _Aer;

			uniform float4 _LightColor0;

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

