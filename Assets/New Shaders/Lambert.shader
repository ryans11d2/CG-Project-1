Shader "Custom/Lambaert"
{
	Properties
	{
		_Color ("Colour", Color) = (1, 0, 0, 1) // Default to red
		_Type ("Amb-Dif-Spec", Range(0, 1)) = 1
		_MainTex ("Texture", 2D) = "white" {}
		_SpecColor("Specular Colour", Color) = (1.0, 1.0, 1.0)
        _Shininess("Shininess", Float) = 10
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
			float _Type;
			uniform float4 _SpecColor;
            uniform float _Shininess;

			uniform float4 _LightColor0;

			sampler2D _MainTex;

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
				float2 uv : TEXCOORD3;//Texture coordinates (pixel from texture to use)
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
				float3 lightFinal = diffuseReflection;
				lightFinal = _Type > 0 ? lightFinal : lightFinal + UNITY_LIGHTMODEL_AMBIENT.xyz;//Add environmental light from unity (for ambient)

				o.col = float4(lightFinal * _Color.rgb, 1.0);//Set o color

				o.pos = UnityObjectToClipPos(v.vertex);//Set position of vertex
				o.posWorld = mul(unity_ObjectToWorld, v.vertex);

				o.uv = v.texcoord;

				o.normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject));

				return o;//return vertex
			}

			float4 frag(vertexOutput i): COLOR//Get fragment color from vertex output
			{
				float3 normalDirection = i.normalDir;
                float atten = 1.0;

                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 diffuseReflection = atten * _LightColor0.xyz * max(0.0, dot(normalDirection, lightDirection));

                float3 lightReflectDirection = reflect(-lightDirection, normalDirection);
                float3 viewDirection = normalize(float3(float4(_WorldSpaceCameraPos.xyz, 1.0) - i.pos.xyz));
                float3 lightSeeDirection = max(0.0, dot(lightReflectDirection, viewDirection));
                float3 shininessPower = pow(lightSeeDirection, _Shininess);


                float3 specularReflection = atten * _SpecColor.rgb * shininessPower;

                //Combine diffuse lighting, ambient lighting, and specular reflection
                float3 lightFinal = diffuseReflection + UNITY_LIGHTMODEL_AMBIENT + specularReflection;

				

				fixed4 col = i.col;

				col = _Type < 1 ? col : float4(lightFinal, 1.0);
				col *= tex2D(_MainTex, i.uv) * i.col;

				return col;//Set fragment color to vertex colour
			}

			ENDCG
		}

		
	}
}

