
Shader "Shape Shader"
{
	Properties
	{
		[TCP2HeaderHelp(Base)]
		_Color ("Color", Color) = (1,1,1,1)
		[TCP2ColorNoAlpha] _HColor ("Highlight Color", Color) = (0.75,0.75,0.75,1)
		[TCP2ColorNoAlpha] _SColor ("Shadow Color", Color) = (0.2,0.2,0.2,1)
		_MainTex ("Albedo", 2D) = "white" {}
		[TCP2Separator]

		[TCP2Header(Ramp Shading)]
		_RampThreshold ("Threshold", Range(0.01,1)) = 0.5
		_RampSmoothing ("Smoothing", Range(0.001,1)) = 0.5
		[TCP2Separator]
		
		[TCP2HeaderHelp(Specular)]
		[TCP2ColorNoAlpha] _SpecularColor ("Specular Color", Color) = (0.5,0.5,0.5,1)
		_SpecularSmoothness ("Smoothness", Float) = 0.2
		_AnisotropicSpread ("Anisotropic Spread", Range(0,2)) = 1
		_SpecularToonSize ("Toon Size", Range(0,1)) = 0.25
		_SpecularToonSmoothness ("Toon Smoothness", Range(0.001,0.5)) = 0.05
		[TCP2Separator]

		[TCP2HeaderHelp(Emission)]
		[TCP2ColorNoAlpha] [HDR] _Emission ("Emission Color", Color) = (0,0,0,1)
		[TCP2Separator]
		
		[TCP2HeaderHelp(Rim Lighting)]
		[TCP2ColorNoAlpha] _RimColor ("Rim Color", Color) = (0.8,0.8,0.8,0.5)
		_RimMinVert ("Rim Min", Range(0,2)) = 0.5
		_RimMaxVert ("Rim Max", Range(0,2)) = 1
		[TCP2Separator]

		[TCP2HeaderHelp(Reflections)]
		[TCP2ColorNoAlpha] _ReflectionColor ("Color", Color) = (1,1,1,1)
		_ReflectionSmoothness ("Smoothness", Range(0,1)) = 0.5
		
		[NoScaleOffset] _Cube ("Reflection Cubemap", Cube) = "black" {}
		[TCP2ColorNoAlpha] _ReflectionCubemapColor ("Color", Color) = (1,1,1,1)
		[TCP2Separator]
		
		[TCP2HeaderHelp(Subsurface Scattering)]
		_SubsurfaceDistortion ("Distortion", Range(0,2)) = 0.2
		_SubsurfacePower ("Power", Range(0.1,16)) = 3
		_SubsurfaceScale ("Scale", Float) = 1
		[TCP2ColorNoAlpha] _SubsurfaceColor ("Color", Color) = (0.5,0.5,0.5,1)
		[TCP2Separator]
		
		//Avoid compile error if the properties are ending with a drawer
		[HideInInspector] __dummy__ ("unused", Float) = 0
	}

	SubShader
	{
		Tags
		{
			"RenderType"="Opaque"
		}
		
		CGINCLUDE

		#include "UnityCG.cginc"
		#include "UnityLightingCommon.cginc"	// needed for LightColor

		// Shader Properties
		sampler2D _MainTex;
		
		// Shader Properties
		float _RimMinVert;
		float _RimMaxVert;
		float4 _MainTex_ST;
		fixed4 _Color;
		half4 _Emission;
		float _RampThreshold;
		float _RampSmoothing;
		fixed4 _HColor;
		fixed4 _SColor;
		float _SubsurfaceDistortion;
		float _SubsurfacePower;
		float _SubsurfaceScale;
		fixed4 _SubsurfaceColor;
		float _AnisotropicSpread;
		float _SpecularSmoothness;
		float _SpecularToonSize;
		float _SpecularToonSmoothness;
		fixed4 _SpecularColor;
		fixed4 _RimColor;
		fixed4 _ReflectionCubemapColor;
		float _ReflectionSmoothness;
		
		samplerCUBE _Cube;

		ENDCG

		// Main Surface Shader

		CGPROGRAM

		#pragma surface surf ToonyColorsCustom vertex:vertex_surface exclude_path:deferred exclude_path:prepass keepalpha nolightmap nofog nolppv
		#pragma target 3.0

		//================================================================
		// STRUCTS

		//Vertex input
		struct appdata_tcp2
		{
			float4 vertex : POSITION;
			float3 normal : NORMAL;
			float4 texcoord0 : TEXCOORD0;
			float4 texcoord1 : TEXCOORD1;
			float4 texcoord2 : TEXCOORD2;
			half4 tangent : TANGENT;
			UNITY_VERTEX_INPUT_INSTANCE_ID
		};

		struct Input
		{
			half3 viewDir;
			half3 tangent;
			half3 worldNormal; INTERNAL_DATA
			half rim;
			float2 texcoord0;
		};

		//================================================================
		// VERTEX FUNCTION

		void vertex_surface(inout appdata_tcp2 v, out Input output)
		{
			UNITY_INITIALIZE_OUTPUT(Input, output);

			// Texture Coordinates
			output.texcoord0.xy = v.texcoord0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
			// Shader Properties Sampling
			float __rimMinVert = ( _RimMinVert );
			float __rimMaxVert = ( _RimMaxVert );

			float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
			half3 viewDir = normalize(UnityWorldSpaceViewDir(worldPos));
			half3 worldNormal = UnityObjectToWorldNormal(v.normal);
			half ndv = abs(dot(viewDir, worldNormal));
			half ndvRaw = ndv;

			output.tangent = mul(unity_ObjectToWorld, float4(v.tangent.xyz, 0)).xyz;
			half rim = 1 - ndvRaw;
			rim = smoothstep(__rimMinVert, __rimMaxVert, rim);
			output.rim = rim;

		}

		//================================================================

		//Custom SurfaceOutput
		struct SurfaceOutputCustom
		{
			half atten;
			half3 Albedo;
			half3 Normal;
			half3 worldNormal;
			half3 Emission;
			half Specular;
			half Gloss;
			half Alpha;
			half ndv;
			half ndvRaw;

			Input input;
			
			// Shader Properties
			float __rampThreshold;
			float __rampSmoothing;
			float3 __highlightColor;
			float3 __shadowColor;
			float __ambientIntensity;
			float __subsurfaceDistortion;
			float __subsurfacePower;
			float __subsurfaceScale;
			float3 __subsurfaceColor;
			float __anisotropicSpread;
			float __specularSmoothness;
			float __specularToonSize;
			float __specularToonSmoothness;
			float3 __specularColor;
			float3 __rimColor;
			float __rimStrength;
			float3 __reflectionCubemapColor;
			float __reflectionSmoothness;
		};

		//================================================================
		// SURFACE FUNCTION

		void surf(Input input, inout SurfaceOutputCustom output)
		{
			
			// Shader Properties Sampling
			float4 __albedo = ( tex2D(_MainTex, input.texcoord0.xy).rgba );
			float4 __mainColor = ( _Color.rgba );
			float __alpha = ( __albedo.a * __mainColor.a );
			float3 __emission = ( _Emission.rgb );
			output.__rampThreshold = ( _RampThreshold );
			output.__rampSmoothing = ( _RampSmoothing );
			output.__highlightColor = ( _HColor.rgb );
			output.__shadowColor = ( _SColor.rgb );
			output.__ambientIntensity = ( 1.0 );
			output.__subsurfaceDistortion = ( _SubsurfaceDistortion );
			output.__subsurfacePower = ( _SubsurfacePower );
			output.__subsurfaceScale = ( _SubsurfaceScale );
			output.__subsurfaceColor = ( _SubsurfaceColor.rgb );
			output.__anisotropicSpread = ( _AnisotropicSpread );
			output.__specularSmoothness = ( _SpecularSmoothness );
			output.__specularToonSize = ( _SpecularToonSize );
			output.__specularToonSmoothness = ( _SpecularToonSmoothness );
			output.__specularColor = ( _SpecularColor.rgb );
			output.__rimColor = ( _RimColor.rgb );
			output.__rimStrength = ( 1.0 );
			output.__reflectionCubemapColor = ( _ReflectionCubemapColor.rgb );
			output.__reflectionSmoothness = ( _ReflectionSmoothness );

			output.input = input;

			half3 worldNormal = WorldNormalVector(input, output.Normal);
			output.worldNormal = worldNormal;

			half ndv = abs(dot(input.viewDir, normalize(output.Normal.xyz)));
			half ndvRaw = ndv;
			output.ndv = ndv;
			output.ndvRaw = ndvRaw;

			output.Albedo = __albedo.rgb;
			output.Alpha = __alpha;
			
			output.Albedo *= __mainColor.rgb;
			output.Emission += __emission;

		}

		//================================================================
		// LIGHTING FUNCTION

		inline half4 LightingToonyColorsCustom(inout SurfaceOutputCustom surface, half3 viewDir, UnityGI gi)
		{
			half ndv = surface.ndv;
			half3 lightDir = gi.light.dir;
			#if defined(UNITY_PASS_FORWARDBASE)
				half3 lightColor = _LightColor0.rgb;
				half atten = surface.atten;
			#else
				//extract attenuation from point/spot lights
				half3 lightColor = _LightColor0.rgb;
				half atten = max(gi.light.color.r, max(gi.light.color.g, gi.light.color.b)) / max(_LightColor0.r, max(_LightColor0.g, _LightColor0.b));
			#endif

			half3 normal = normalize(surface.Normal);
			half ndl = dot(normal, lightDir);
			half3 ramp;
			
			#define		RAMP_THRESHOLD	surface.__rampThreshold
			#define		RAMP_SMOOTH		surface.__rampSmoothing
			ndl = saturate(ndl);
			ramp = smoothstep(RAMP_THRESHOLD - RAMP_SMOOTH*0.5, RAMP_THRESHOLD + RAMP_SMOOTH*0.5, ndl);
			half3 rampGrayscale = ramp;

			//Apply attenuation (shadowmaps & point/spot lights attenuation)
			ramp *= atten;

			//Highlight/Shadow Colors
			#if !defined(UNITY_PASS_FORWARDBASE)
				ramp = lerp(half3(0,0,0), surface.__highlightColor, ramp);
			#else
				ramp = lerp(surface.__shadowColor, surface.__highlightColor, ramp);
			#endif

			//Output color
			half4 color;
			color.rgb = surface.Albedo * lightColor.rgb * ramp;
			color.a = surface.Alpha;

			// Apply indirect lighting (ambient)
			half occlusion = 1;
			#ifdef UNITY_LIGHT_FUNCTION_APPLY_INDIRECT
				half3 ambient = gi.indirect.diffuse;
				ambient *= surface.Albedo * occlusion * surface.__ambientIntensity;

				color.rgb += ambient;
			#endif

				//Subsurface Scattering
				half3 ssLight = lightDir + normal * surface.__subsurfaceDistortion;
				half ssDot = pow(saturate(dot(viewDir, -ssLight)), surface.__subsurfacePower) * surface.__subsurfaceScale;
				half3 ssColor = (ssDot * surface.__subsurfaceColor);
			#if !defined(UNITY_PASS_FORWARDBASE)
				ssColor *= atten;
			#endif
				ssColor *= lightColor;
				color.rgb += surface.Albedo * ssColor;

			//Anisotropic Specular
			half3 h = normalize(lightDir + viewDir);
			float ndh = max(0, dot (normal, h));
			half3 binorm = cross(normal, surface.input.tangent);
			float aX = dot(h, surface.input.tangent) / surface.__anisotropicSpread;
			float aY = dot(h, binorm) / surface.__specularSmoothness;
			float specAniso = sqrt(max(0.0, ndl / surface.ndvRaw)) * exp(-2.0 * (aX * aX + aY * aY) / (1.0 + ndh));
			float spec = smoothstep(surface.__specularToonSize + surface.__specularToonSmoothness, surface.__specularToonSize - surface.__specularToonSmoothness,1 - (specAniso / (1+surface.__specularToonSmoothness)));
			spec = saturate(spec);
			spec *= atten;
			
			//Apply specular
			color.rgb += spec * lightColor.rgb * surface.__specularColor;
			// Rim Lighting
			#if !defined(UNITY_PASS_FORWARDADD)
			half rim = surface.input.rim;
			rim = ( rim );
			half3 rimColor = surface.__rimColor;
			half rimStrength = surface.__rimStrength;
			color.rgb += rim * rimColor * rimStrength;
			#endif
			// ForwardBase pass only
			#if !defined(UNITY_PASS_FORWARDADD)

					// Reflection probes/skybox
					half3 reflections = gi.indirect.specular * occlusion;
					// Reflection cubemap
					half3 reflectVector = reflect(-viewDir, surface.worldNormal);
					reflections.rgb += texCUBE(_Cube, reflectVector).rgb;
					reflections.rgb *= surface.__reflectionCubemapColor;
					color.rgb += reflections;

			#endif

			return color;
		}

		void LightingToonyColorsCustom_GI(inout SurfaceOutputCustom surface, UnityGIInput data, inout UnityGI gi)
		{
			half3 normal = surface.Normal;

			//GI with reflection probes support
			half smoothness = surface.__reflectionSmoothness;
			Unity_GlossyEnvironmentData g = UnityGlossyEnvironmentSetup(smoothness, data.worldViewDir, normal, half3(0,0,0));	// last parameter is actually unused
			gi = UnityGlobalIllumination(data, 1.0, normal, g); // occlusion is applied in the lighting function, if necessary

			surface.atten = data.atten; // transfer attenuation to lighting function
			gi.light.color = _LightColor0.rgb; // remove attenuation

		}

		ENDCG

	}

	Fallback "Diffuse"
}

/* TCP_DATA u config(unity:"2020.2.1f1";ver:"2.6.4";tmplt:"SG2_Template_Default";features:list["UNITY_5_4","UNITY_5_5","UNITY_5_6","UNITY_2017_1","UNITY_2018_1","UNITY_2018_2","UNITY_2018_3","UNITY_2019_1","UNITY_2019_2","UNITY_2019_3","SPECULAR_ANISOTROPIC","SPECULAR","SPECULAR_TOON","EMISSION","RIM","RIM_VERTEX","SUBSURFACE_SCATTERING","GLOSSY_REFLECTIONS","SS_ALL_LIGHTS","REFLECTION_CUBEMAP"];flags:list[];flags_extra:dict[];keywords:dict[RENDER_TYPE="Opaque",RampTextureDrawer="[TCP2Gradient]",RampTextureLabel="Ramp Texture",SHADER_TARGET="3.0",RIM_LABEL="Rim Lighting"];shaderProperties:list[];customTextures:list[];codeInjection:codeInjection(injectedFiles:list[];mark:False)) */
/* TCP_HASH 260daa02755d190d08c74479b5d67a28 */
