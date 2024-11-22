Shader "Custom/Pach"
{

	/*

	Multipurpose, Supports:

	-Colour
	-Texture
	-Bump Map (Specular Only)
	-Ambient, Specular, or Diffuse Lighting
	-Outline
	-Texture Scroll

	*/

	Properties
	{
		_Color ("Colour", Color) = (1, 0, 0, 1)//Colour
		_MainTex ("Texture", 2D) = "white" {}//Texture
		_BumpMap ("Bump Texture", 2D) = "bump" {}//Bump Map
        _Bump ("Bump Amount", Range(0, 10)) = 1//Bump Map Depth
		_Type ("Amb-Dif-Spec", Range(0, 1)) = 1//Lighting Type, if slider = 0: ambient, 1: specular, otherwise: diffuse
		_SpecColor("Specular Colour", Color) = (1.0, 1.0, 1.0)//Shine Colour
        _Shininess("Shininess", Float) = 10//Shine
		_OutlineColor ("Colour", Color) = (1,1,1,1)//Outline Colour
        _Outline ("Outline Width", Range (0, 1)) = 0//Outline Width
		_ScrollX ("Scroll X", Range(-5, 5)) = 1
        _ScrollY ("Scroll Y", Range(-5, 5)) = 1
		_Atten ("Atten", Range(-1, 2)) = 1
	}

	SubShader
	{

		Tags {"Queue" = "Transparent"}
        ZWrite off

        CGPROGRAM

            #pragma surface surf Lambert vertex:vert

            struct Input
            {
                float2 uv_MainTex;
            };
        
            float _Outline;
            float4 _OutlineColor;
        
            void vert (inout appdata_full v) {
                //v.vertex.xyz += v.normal * _Outline;
                v.vertex.xyz *= 1 + _Outline;
            }

            sampler2D _MainTex;

            void surf (Input IN, inout SurfaceOutput o)
            {
                o.Emission = _OutlineColor.rgb;
            }

        ENDCG

        ZWrite on



		Tags {"LightMode" = "ForwardBase"}
	
		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			uniform float4 _Color;
			float _Type;
			float _Atten;
			uniform float4 _SpecColor;
            uniform float _Shininess;
			float _ScrollX;
			float _ScrollY;

			sampler2D _MainTex;
			sampler2D _BumpMap;

			uniform float _Bump;

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
				float2 uv : TEXCOORD3;//Texture coordinates (pixel from texture to use)
			};

			vertexOutput vert(vertexInput v) 
			{
				vertexOutput o;//o has the pos and col col variables of vertexOutput
				//Calculate output o variables using input v information and return o

				float3 normalDirection = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
				float3 lightDirection;
				float atten = _Atten;
			
				lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				
				//Calculate diffuse reflection using normal and light direction gathered above
				float3 diffuseReflection = atten * _LightColor0.xyz * max(0.0, dot(normalDirection, lightDirection));
				
				//Calculate Ambient Light
				float3 lightFinal = diffuseReflection;
				lightFinal = _Type > 0 ? lightFinal : lightFinal + UNITY_LIGHTMODEL_AMBIENT.xyz;//Add environmental light from unity (for ambient)

				o.col = float4(lightFinal * _Color.rgb, 1.0);//Set o color

				o.pos = UnityObjectToClipPos(v.vertex);//Set position of vertex
				o.posWorld = mul(unity_ObjectToWorld, v.vertex);

				o.uv = v.texcoord;//Texture coordinates for vertex

				o.normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject));//Save normal direction (for specular)

				return o;//return vertex
			}

			float4 frag(vertexOutput i): COLOR//Get fragment color from vertex output
			{

				float2 scroll = (_ScrollX * _Time, _ScrollY * _Time);

				//Specular Lighting Data
				float3 normalDirection = i.normalDir;//Use predetermined normal direction
				normalDirection *= tex2D(_BumpMap, i.uv + scroll) * _Bump;//Add bump map normals
                float atten = _Atten;

                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);//Get light direction
                float3 diffuseReflection = atten * _LightColor0.xyz * max(0.0, dot(normalDirection, lightDirection));

                float3 lightReflectDirection = reflect(-lightDirection, normalDirection);//Reflect light backwards in normal direction
                float3 viewDirection = normalize(float3(float4(_WorldSpaceCameraPos.xyz, 1.0) - i.pos.xyz));//Get angle to s
                float3 lightSeeDirection = max(0.0, dot(lightReflectDirection, viewDirection));
                float3 shininessPower = pow(lightSeeDirection, _Shininess);

                float3 specularReflection = atten * _SpecColor.rgb * shininessPower;

                //Combine diffuse lighting, ambient lighting, and specular reflection
                float3 lightFinal = diffuseReflection + UNITY_LIGHTMODEL_AMBIENT + specularReflection;

				

				fixed4 col = i.col;//Setup colour

				col = _Type < 1 ? col : float4(lightFinal, 1.0);//If type = 1, use specular lighting
				col *= tex2D(_MainTex, i.uv + scroll) * i.col;//Add texture and color

				return col;//Set fragment color to vertex colour
			}

			ENDCG
		}

		
	}
}

