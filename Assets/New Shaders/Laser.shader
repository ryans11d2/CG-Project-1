Shader "Game/Laser"
{
	Properties
	{
		_Color ("Colour", Color) = (1, 0, 0, 1) //Laser Colour (Amplitude)
		_Scroll ("Scroll", Range(-10, 10)) = 1//Colour Offset (horizontal shift)
		_Stretch ("Stretch", float) = 0.4//Colour Stretch (Frequency)
		_Shift ("Colour Shift", float) = 2//Colour shift (vertical shift)
		_Freq ("Pulse Frequency", float) = 100
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
			float _Scroll;
			float _Stretch;
			float _Shift;
			float _Freq;

			uniform float4 _LightColor0;


			struct vertexInput//vertexInput component
			{
				float4 vertex: POSITION;//Vertex position
				float4 texcoord: TEXCOORD;
			};

			struct vertexOutput//vertexOutput component
			{
				float4 pos: SV_POSITION;//Vertex position
				float2 uv: TEXCOORD0;
			};

			vertexOutput vert(vertexInput v) 
			{
				vertexOutput o;//o has the pos and col col variables of vertexOutput
		
				o.pos = UnityObjectToClipPos(v.vertex);//Set position of vertex
				o.uv = v.texcoord;

				return o;//return vertex
			}

			float4 frag(vertexOutput i): COLOR//Get fragment color from vertex output
			{	
				fixed4 col = _Color;//Set base colour

				_Scroll *= _Time;//Scale scroll variable by time

				//Set colour based on pixel coordinates so colour fluxuates, add scroll for apearance of movement
				col *= abs(sin((i.uv.y + _Scroll) * _Stretch)) + _Shift;
				
				float pulse = abs(sin(_Time * _Freq));//Set pulse (based on sin of time for value that raises and lowers)

				col *= pulse;//Multiply colour by pulse for fading effect

				return col;//Set fragment colour to vertex colour
			}

			ENDCG
		}

		
	}
}

