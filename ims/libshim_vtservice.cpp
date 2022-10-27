#include <gui/SurfaceComposerClient.h>
#include <media/AudioTrack.h>

using namespace android;

extern "C" {
   void _ZN7android10AudioTrackC1E19audio_stream_type_tj14audio_format_tjj20audio_output_flags_tPFviPvS4_ES4_i15audio_session_tNS0_13transfer_typeEPK20audio_offload_info_tjiPK18audio_attributes_tbfi(
           audio_stream_type_t streamType,
           uint32_t sampleRate,
           audio_format_t format,
           audio_channel_mask_t channelMask,
           size_t frameCount,
           audio_output_flags_t flags,
           android::AudioTrack::callback_t cbf,
           void* user,
           int32_t notificationFrames,
           audio_session_t sessionId,
           android::AudioTrack::transfer_type transferType,
           const audio_offload_info_t *offloadInfo,
           uid_t uid,
           pid_t pid,
           const audio_attributes_t* pAttributes,
           bool doNotReconnect,
           float maxRequiredSpeed,
           audio_port_handle_t selectedDeviceId) {
       const AttributionSourceState& attributionSource = AttributionSourceState();
       new android::AudioTrack(streamType, sampleRate, format, channelMask, frameCount, flags, cbf,
                               user, notificationFrames, sessionId, transferType, offloadInfo, attributionSource,
                               pAttributes, doNotReconnect, maxRequiredSpeed, selectedDeviceId);
           }
   
   void _ZN7android7SurfaceC1ERKNS_2spINS_22IGraphicBufferProducerEEEbRKNS1_INS_7IBinderEEE(
       void* thisptr, const sp<IGraphicBufferProducer>& bufferProducer, bool controlledByApp, const sp<IBinder>& surfaceControlHandle);
   
   void _ZN7android7SurfaceC1ERKNS_2spINS_22IGraphicBufferProducerEEEb(
       void* thisptr, const sp<IGraphicBufferProducer> &bufferProducer, bool controlledByApp) {
           _ZN7android7SurfaceC1ERKNS_2spINS_22IGraphicBufferProducerEEEbRKNS1_INS_7IBinderEEE(thisptr, bufferProducer, controlledByApp, nullptr);
   }
   
   void _ZN7android11AudioSourceC1E14audio_source_tRKNS_8String16Ejjjjii28audio_microphone_direction_tf(audio_source_t inputSource, const String16 &opPackageName,
       uint32_t sampleRate, uint32_t channels, uint32_t outSampleRate, uid_t uid, pid_t pid,
       audio_port_handle_t selectedDeviceId, int32_t selectedMicDirection, float selectedMicFieldDimension);
   
   int _ZN7android10MediaMuxerC1EiNS0_12OutputFormatE[6] = { 0, 1, 2, 3, 4, NULL };
}