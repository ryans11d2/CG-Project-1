Shader "Game/SmallWall"
{
	Properties
	{
		_Color ("Colour", Color) = (1, 0, 0, 1) // Default to red
		_MainTex ("Texture", 2D) = "white" {}
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
			
				lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				
				//Calculate diffuse reflection using normal and light direction gathered above
				float3 diffuseReflection = atten * _LightColor0.xyz * max(0.0, dot(normalDirection, lightDirection));
				float3 light_final = diffuseReflection + UNITY_LIGHTMODEL_AMBIENT.xyz;

				o.col = float4(light_final * _Color.rgb, 1.0);//Set o color

				o.pos = UnityObjectToClipPos(v.vertex);//Set position of vertex

				o.uv = v.texcoord;

				return o;//return vertex
			}

			float4 frag(vertexOutput i): COLOR//Get fragment color from vertex output
			{	
				fixed4 col = i.col;

				col *= tex2D(_MainTex, i.uv);

				return col;//Set fragment color to vertex colour
			}

			ENDCG
		}

		
	}
}

