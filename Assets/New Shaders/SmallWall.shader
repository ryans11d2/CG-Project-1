Shader "Game/SmallWall"
{
	Properties
	{
		_Color ("Colour", Color) = (1, 1, 1, 1)//Colour
		_MainTex ("Texture", 2D) = "white" {}//Texture
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
			};

			vertexOutput vert(vertexInput v) 
			{
				vertexOutput o;//o has the pos and col col variables of vertexOutput
				
				//Calculate output o variables using input v information and return o
				float3 normalDirection = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
				float3 lightDirection;
				float atten = 1.0;
			
				lightDirection = normalize(_WorldSpaceLightPos0.xyz);//Get position of light
				
				//Calculate diffuse reflection based on the direction to the light source, and the vertex normal
				float3 diffuseReflection = atten * _LightColor0.xyz * max(0.0, dot(normalDirection, lightDirection));
				float3 light_final = diffuseReflection + UNITY_LIGHTMODEL_AMBIENT.xyz;//Add ambient light

				o.col = float4(light_final * _Color.rgb, 1.0);//Add colour

				o.pos = UnityObjectToClipPos(v.vertex);//Set position of vertex

				o.uv = v.texcoord;//Get uv coordinates

				return o;//return vertex
			}

			float4 frag(vertexOutput i): COLOR//Get fragment color from vertex output
			{	
				fixed4 col = i.col;//Set fragment colour to vertex output colour

				col *= tex2D(_MainTex, i.uv);//Add texture to colour

				return col;//Set fragment color to vertex colour
			}

			ENDCG
		}

		
	}
}

