import Foundation

class PluginManagerDemoData {
	
	private var demoData = [Triplet<String>]()
	
	func buildTriplet(csvLine: String) -> [Triplet<String>] {
		let parts = csvLine.split(separator: ",")
		if parts.count == 3 {
			let s0 = String(parts[0]); let s1 = String(parts[1]); let s2 = String(parts[2])
			return [Triplet(p0: s0, p1: s1, p2: s2)]
		}
		return [Triplet(p0: "invalid", p1: "invalid", p2: "invalid")]
	}
	
	func getDemoData() -> [Triplet<String>] {
		var demoData: [Triplet<String>] =  [Triplet<String>]()
		demoData += buildTriplet(csvLine: "audio,audio.vital.synth,Vital.clap")
		demoData += buildTriplet(csvLine: "audiodamage,com.audiodamage.dubstation2,Dubstation 2.clap")
		demoData += buildTriplet(csvLine: "audiomodern,com.audiomodern.chordjam,Chordjam.clap")
		demoData += buildTriplet(csvLine: "audiority,com.audiority.polaris,Audiority/Polaris.clap")
		demoData += buildTriplet(csvLine: "audiority,com.audiority.spacestationum282,Audiority/Space Station UM282.clap")
		demoData += buildTriplet(csvLine: "audiothing,com.audiothing.blindfoldeq,BlindfoldEQ.clap")
		demoData += buildTriplet(csvLine: "audiothing,com.audiothing.filterjam,Filterjam.clap")
		demoData += buildTriplet(csvLine: "audiothing,com.audiothing.fogconvolver2,FogConvolver2.clap")
		demoData += buildTriplet(csvLine: "audiothing,com.audiothing.noises,Noises.clap")
		demoData += buildTriplet(csvLine: "audiothing,com.audiothing.outerspace,OuterSpace.clap")
		demoData += buildTriplet(csvLine: "audiothing,com.audiothing.spacestrip,SpaceStrip.clap")
		demoData += buildTriplet(csvLine: "audiothing,com.audiothing.springs,Springs.clap")
		demoData += buildTriplet(csvLine: "audiothing,com.audiothing.thingsbubbles,ThingsBubbles.clap")
		demoData += buildTriplet(csvLine: "audiothing,com.audiothing.thingscrusher,ThingsCrusher.clap")
		demoData += buildTriplet(csvLine: "audiothing,com.audiothing.thingsflipeq,ThingsFlipEQ.clap")
		demoData += buildTriplet(csvLine: "audiothing,com.audiothing.thingsmotor,ThingsMotor.clap")
		demoData += buildTriplet(csvLine: "audiothing,com.audiothing.thingstexture,ThingsTexture.clap")
		demoData += buildTriplet(csvLine: "audiothing,com.audiothing.valves,Valves.clap")
		demoData += buildTriplet(csvLine: "birdbird,com.birdbird.birdsampler,Rolling Sampler.clap")
		demoData += buildTriplet(csvLine: "chowdsp,org.chowdsp.byod,BYOD.clap")
		demoData += buildTriplet(csvLine: "chowdsp,org.chowdsp.chowtapemodel,CHOWTapeModel.clap")
		demoData += buildTriplet(csvLine: "chowdsp,org.chowdsp.chowkick,ChowKick.clap")
		demoData += buildTriplet(csvLine: "chowdsp,org.chowdsp.chowmultitool,ChowMultiTool.clap")
		demoData += buildTriplet(csvLine: "cwitec,com.cwitec.tx16wx,TX16Wx.clap")
		demoData += buildTriplet(csvLine: "josephlyncheski,com.josephlyncheski.minimetersserver,MiniMetersServer.clap")
		demoData += buildTriplet(csvLine: "nakst,nakst.apricot,Apricot.clap")
		demoData += buildTriplet(csvLine: "nakst,nakst.fluctus,Fluctus.clap")
		demoData += buildTriplet(csvLine: "nakst,nakst.regency,Regency.clap")
		demoData += buildTriplet(csvLine: "sonosaurus,com.sonosaurus.paulxstretch,PaulXStretch.clap")
		demoData += buildTriplet(csvLine: "studio,studio.kx.distrho.aida-x,AIDA-X.clap")
		demoData += buildTriplet(csvLine: "studio,studio.kx.distrho.wstd_dl3y,WSTD_DL3Y.clap")
		demoData += buildTriplet(csvLine: "studio,studio.kx.distrho.wstd_fl3ngr,WSTD_FL3NGR.clap")
		demoData += buildTriplet(csvLine: "surge-synth-team,org.surge-synth-team.surge-xt-fx,Surge XT Effects.clap")
		demoData += buildTriplet(csvLine: "surge-synth-team,org.surge-synth-team.surge-xt,Surge XT.clap")
		demoData += buildTriplet(csvLine: "the wave warden,,Odin2.clap")
		demoData += buildTriplet(csvLine: "theusualsuspects,com.theusualsuspects.tusv,Osirus.clap")
		demoData += buildTriplet(csvLine: "theusualsuspects,com.theusualsuspects.tmqs,Vavra.clap")
		demoData += buildTriplet(csvLine: "timothyschoen,com.timothyschoen.plugdata-fx,plugdata-fx.clap")
		demoData += buildTriplet(csvLine: "timothyschoen,com.timothyschoen.plugdata,plugdata.clap")
		demoData += buildTriplet(csvLine: "toguaudioline,ch.toguaudioline.talnoisemaker,TAL-NoiseMaker.clap")
		demoData += buildTriplet(csvLine: "vcvrack,com.vcvrack.rack,VCV Rack 2.clap")
		return demoData
	}
}
	


