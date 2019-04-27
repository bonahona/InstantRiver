Shader "MageQuest/WaterShader"
{
    Properties
	{ 
		_Color("Color (RBGa)", Color) = (1,1,1,1)
		_NormalTex("Normal", 2D) = "" {}
		_NormalFactor("Normal Factor", Range(0, 1)) = 1
		_Glossiness("Glossiness", Range(0,1)) = 0.5
		_DepthFactor("Depth Factor", Range(0, 10)) = 1
		_FoamDepth("Foam Depth", Range(0, 5)) = 5
		_FoamStrength("Foam Strength", Range(0, 10)) = 1
		_FoamColor("Foam Color", Color) = (1, 1, 1, 1)
		_FlowRate("Flow Rate", Range(-10, 10)) = 0
    }
    SubShader
    {
        Tags {
			"RenderType" = "Transparent"
			"Queue" = "Transparent"
		}
        LOD 200

		GrabPass {
			"_BackgroundTex"
		}
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard alpha addshadow

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

		sampler2D _NormalTex;
		sampler2D _CameraDepthTexture;
		sampler2D _BackgroundTex;

		float4 _CameraDepthTexture_TexelSize;

		fixed4 _Color;
		fixed4 _FoamColor;
		fixed _NormalFactor;
		fixed _Glossiness;
		fixed _DepthFactor;
		fixed _FoamDepth;
		fixed _FoamStrength;
		fixed _FlowRate;

        struct Input
        {
            float2 uv_NormalTex;
			float4 screenPos;
        };
		

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			o.Normal = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex + float2(1, 0) * _Time.w * 0.02 * _FlowRate));
			o.Normal.rg *= _NormalFactor;
			o.Normal = normalize(o.Normal);
			o.Smoothness = _Glossiness;

			float2 depthUv = IN.screenPos.xy / IN.screenPos.w;
			float backgroundDepth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, depthUv));
			float surfaceDepth = UNITY_Z_0_FAR_FROM_CLIPSPACE(IN.screenPos.z);
			fixed depth = backgroundDepth - surfaceDepth;
			fixed normalizedDepth = clamp(depth / _DepthFactor, 0, 1);

			fixed2 uvOffset = o.Normal.xy;
			uvOffset *= normalizedDepth;
			fixed2 uv = (IN.screenPos.xy + uvOffset) / IN.screenPos.w;


			fixed3 backgroundColor = tex2D(_BackgroundTex, uv).rgb;
			fixed3 color = lerp(backgroundColor, _Color.rgb, pow(normalizedDepth, 2));


			fixed floamStrength = pow(clamp((depth / _FoamDepth) + o.Normal.y, 0, 1), _FoamStrength);
			fixed3 foamColor = (1 - floamStrength) * _FoamColor.rgb;

			o.Albedo = (color * depth) + foamColor;
			o.Alpha = 1;
        }

		void ResetAlpha(Input IN, SurfaceOutputStandard o, inout fixed4 color) {
			color.a = 1;
		}

        ENDCG
    }
}
