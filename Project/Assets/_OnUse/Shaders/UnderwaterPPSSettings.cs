// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>
#if UNITY_POST_PROCESSING_STACK_V2
using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess( typeof( UnderwaterPPSRenderer ), PostProcessEvent.AfterStack, "Underwater", true )]
public sealed class UnderwaterPPSSettings : PostProcessEffectSettings
{
	[Tooltip( "Texture Sample 1" )]
	public TextureParameter _TextureSample1 = new TextureParameter {  };
	[Tooltip( "FlowmapIntensity" )]
	public FloatParameter _FlowmapIntensity = new FloatParameter { value = 0.31f };
}

public sealed class UnderwaterPPSRenderer : PostProcessEffectRenderer<UnderwaterPPSSettings>
{
	public override void Render( PostProcessRenderContext context )
	{
		var sheet = context.propertySheets.Get( Shader.Find( "Underwater" ) );
		if(settings._TextureSample1.value != null) sheet.properties.SetTexture( "_TextureSample1", settings._TextureSample1 );
		sheet.properties.SetFloat( "_FlowmapIntensity", settings._FlowmapIntensity );
		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
	}
}
#endif
