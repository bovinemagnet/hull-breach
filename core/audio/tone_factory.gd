class_name ToneFactory
extends RefCounted

const MIX_RATE := 22050


static func create_tone(
	frequency: float,
	duration: float,
	volume: float = 0.2,
	decay: bool = true
) -> AudioStreamWAV:
	var sample_count := maxi(1, int(duration * MIX_RATE))
	var data := PackedByteArray()
	data.resize(sample_count * 2)
	for sample_index in sample_count:
		var time := float(sample_index) / float(MIX_RATE)
		var envelope := 1.0 - (float(sample_index) / float(sample_count)) if decay else 1.0
		var sample := int(sin(TAU * frequency * time) * 32767.0 * volume * envelope)
		data.encode_s16(sample_index * 2, sample)

	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = MIX_RATE
	stream.stereo = false
	stream.data = data
	return stream
