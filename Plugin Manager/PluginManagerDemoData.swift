import Foundation

class PluginManagerDemoData {
	
	private var demoData = [PluginTriplet<String>]()
	
	func buildTriplet(csvLine: String) -> [PluginTriplet<String>] {
		let parts = csvLine.split(separator: ",")
		if parts.count == 3 {
			let s0 = String(parts[0]); let s1 = String(parts[1]); let s2 = String(parts[2])
			return [PluginTriplet(manufacturer: s0, plugin: s1, ident: s2)]
		}
		return [PluginTriplet(manufacturer: "invalid", plugin: "invalid", ident: "invalid")]
	}
	
	func getDemoData() -> [PluginTriplet<String>] {
		var demoData: [PluginTriplet<String>] =  [PluginTriplet<String>]()
		demoData += buildTriplet(csvLine: "audio,Vital.clap,audio.vital.synth")
		demoData += buildTriplet(csvLine: "audiodamage,Dubstation 2.clap,com.audiodamage.dubstation2")
		demoData += buildTriplet(csvLine: "audiomodern,Chordjam.clap,com.audiomodern.chordjam")
		demoData += buildTriplet(csvLine: "audiority,Audiority/Polaris.clap,com.audiority.polaris")
		demoData += buildTriplet(csvLine: "audiority,Audiority/Space Station UM282.clap,com.audiority.spacestationum282")
		demoData += buildTriplet(csvLine: "audiothing,BlindfoldEQ.clap,com.audiothing.blindfoldeq")
		demoData += buildTriplet(csvLine: "audiothing,Filterjam.clap,com.audiothing.filterjam")
		demoData += buildTriplet(csvLine: "audiothing,FogConvolver2.clap,com.audiothing.fogconvolver2")
		demoData += buildTriplet(csvLine: "audiothing,Noises.clap,com.audiothing.noises")
		demoData += buildTriplet(csvLine: "audiothing,OuterSpace.clap,com.audiothing.outerspace")
		demoData += buildTriplet(csvLine: "audiothing,SpaceStrip.clap,com.audiothing.spacestrip")
		demoData += buildTriplet(csvLine: "audiothing,Springs.clap,com.audiothing.springs")
		demoData += buildTriplet(csvLine: "audiothing,ThingsBubbles.clap,com.audiothing.thingsbubbles")
		demoData += buildTriplet(csvLine: "audiothing,ThingsCrusher.clap,com.audiothing.thingscrusher")
		demoData += buildTriplet(csvLine: "audiothing,ThingsFlipEQ.clap,com.audiothing.thingsflipeq")
		demoData += buildTriplet(csvLine: "audiothing,ThingsMotor.clap,com.audiothing.thingsmotor")
		demoData += buildTriplet(csvLine: "audiothing,ThingsTexture.clap,com.audiothing.thingstexture")
		demoData += buildTriplet(csvLine: "audiothing,Valves.clap,com.audiothing.valves")
		demoData += buildTriplet(csvLine: "birdbird,Rolling Sampler.clap,com.birdbird.birdsampler")
		demoData += buildTriplet(csvLine: "chowdsp,BYOD.clap,org.chowdsp.byod")
		demoData += buildTriplet(csvLine: "chowdsp,CHOWTapeModel.clap,org.chowdsp.chowtapemodel")
		demoData += buildTriplet(csvLine: "chowdsp,ChowKick.clap,org.chowdsp.chowkick")
		demoData += buildTriplet(csvLine: "chowdsp,ChowMultiTool.clap,org.chowdsp.chowmultitool")
		demoData += buildTriplet(csvLine: "cwitec,TX16Wx.clap,com.cwitec.tx16wx")
		demoData += buildTriplet(csvLine: "josephlyncheski,MiniMetersServer.clap,com.josephlyncheski.minimetersserver")
		demoData += buildTriplet(csvLine: "nakst,Apricot.clap,nakst.apricot")
		demoData += buildTriplet(csvLine: "nakst,Fluctus.clap,nakst.fluctus")
		demoData += buildTriplet(csvLine: "nakst,Regency.clap,nakst.regency")
		demoData += buildTriplet(csvLine: "sonosaurus,PaulXStretch.clap,com.sonosaurus.paulxstretch")
		demoData += buildTriplet(csvLine: "studio,AIDA-X.clap,studio.kx.distrho.aida-x")
		demoData += buildTriplet(csvLine: "studio,WSTD_DL3Y.clap,studio.kx.distrho.wstd_dl3y")
		demoData += buildTriplet(csvLine: "studio,WSTD_FL3NGR.clap,studio.kx.distrho.wstd_fl3ngr")
		demoData += buildTriplet(csvLine: "surge-synth-team,Surge XT Effects.clap,org.surge-synth-team.surge-xt-fx")
		demoData += buildTriplet(csvLine: "surge-synth-team,Surge XT.clap,org.surge-synth-team.surge-xt")
		demoData += buildTriplet(csvLine: "theusualsuspects,Osirus.clap,com.theusualsuspects.tusv")
		demoData += buildTriplet(csvLine: "theusualsuspects,Vavra.clap,com.theusualsuspects.tmqs")
		demoData += buildTriplet(csvLine: "timothyschoen,plugdata-fx.clap,com.timothyschoen.plugdata-fx")
		demoData += buildTriplet(csvLine: "timothyschoen,plugdata.clap,com.timothyschoen.plugdata")
		demoData += buildTriplet(csvLine: "toguaudioline,TAL-NoiseMaker.clap,ch.toguaudioline.talnoisemaker")
		demoData += buildTriplet(csvLine: "vcvrack,VCV Rack 2.clap,com.vcvrack.rack")
		return demoData
	}
}
	


