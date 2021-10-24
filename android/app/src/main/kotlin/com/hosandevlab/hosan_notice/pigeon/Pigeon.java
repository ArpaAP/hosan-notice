// Autogenerated from Pigeon (v1.0.7), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package com.hosandevlab.hosan_notice.pigeon;

import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.common.StandardMessageCodec;
import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

/** Generated class from Pigeon. */
@SuppressWarnings({"unused", "unchecked", "CodeBlock2Expr", "RedundantSuppression"})
public class Pigeon {

  /** Generated class from Pigeon that represents data sent in messages. */
  public static class MinewBeaconData {
    private String uuid;
    public String getUuid() { return uuid; }
    public void setUuid(String setterArg) { this.uuid = setterArg; }

    private String name;
    public String getName() { return name; }
    public void setName(String setterArg) { this.name = setterArg; }

    private Long major;
    public Long getMajor() { return major; }
    public void setMajor(Long setterArg) { this.major = setterArg; }

    private Long minor;
    public Long getMinor() { return minor; }
    public void setMinor(Long setterArg) { this.minor = setterArg; }

    private String mac;
    public String getMac() { return mac; }
    public void setMac(String setterArg) { this.mac = setterArg; }

    private Long rssi;
    public Long getRssi() { return rssi; }
    public void setRssi(Long setterArg) { this.rssi = setterArg; }

    private Long batteryLevel;
    public Long getBatteryLevel() { return batteryLevel; }
    public void setBatteryLevel(Long setterArg) { this.batteryLevel = setterArg; }

    private Double temperature;
    public Double getTemperature() { return temperature; }
    public void setTemperature(Double setterArg) { this.temperature = setterArg; }

    private Double humidity;
    public Double getHumidity() { return humidity; }
    public void setHumidity(Double setterArg) { this.humidity = setterArg; }

    private Long txPower;
    public Long getTxPower() { return txPower; }
    public void setTxPower(Long setterArg) { this.txPower = setterArg; }

    private Boolean inRange;
    public Boolean getInRange() { return inRange; }
    public void setInRange(Boolean setterArg) { this.inRange = setterArg; }

    Map<String, Object> toMap() {
      Map<String, Object> toMapResult = new HashMap<>();
      toMapResult.put("uuid", uuid);
      toMapResult.put("name", name);
      toMapResult.put("major", major);
      toMapResult.put("minor", minor);
      toMapResult.put("mac", mac);
      toMapResult.put("rssi", rssi);
      toMapResult.put("batteryLevel", batteryLevel);
      toMapResult.put("temperature", temperature);
      toMapResult.put("humidity", humidity);
      toMapResult.put("txPower", txPower);
      toMapResult.put("inRange", inRange);
      return toMapResult;
    }
    static MinewBeaconData fromMap(Map<String, Object> map) {
      MinewBeaconData fromMapResult = new MinewBeaconData();
      Object uuid = map.get("uuid");
      fromMapResult.uuid = (String)uuid;
      Object name = map.get("name");
      fromMapResult.name = (String)name;
      Object major = map.get("major");
      fromMapResult.major = (major == null) ? null : ((major instanceof Integer) ? (Integer)major : (Long)major);
      Object minor = map.get("minor");
      fromMapResult.minor = (minor == null) ? null : ((minor instanceof Integer) ? (Integer)minor : (Long)minor);
      Object mac = map.get("mac");
      fromMapResult.mac = (String)mac;
      Object rssi = map.get("rssi");
      fromMapResult.rssi = (rssi == null) ? null : ((rssi instanceof Integer) ? (Integer)rssi : (Long)rssi);
      Object batteryLevel = map.get("batteryLevel");
      fromMapResult.batteryLevel = (batteryLevel == null) ? null : ((batteryLevel instanceof Integer) ? (Integer)batteryLevel : (Long)batteryLevel);
      Object temperature = map.get("temperature");
      fromMapResult.temperature = (Double)temperature;
      Object humidity = map.get("humidity");
      fromMapResult.humidity = (Double)humidity;
      Object txPower = map.get("txPower");
      fromMapResult.txPower = (txPower == null) ? null : ((txPower instanceof Integer) ? (Integer)txPower : (Long)txPower);
      Object inRange = map.get("inRange");
      fromMapResult.inRange = (Boolean)inRange;
      return fromMapResult;
    }
  }
  private static class ApiCodec extends StandardMessageCodec {
    public static final ApiCodec INSTANCE = new ApiCodec();
    private ApiCodec() {}
    @Override
    protected Object readValueOfType(byte type, ByteBuffer buffer) {
      switch (type) {
        case (byte)128:         
          return MinewBeaconData.fromMap((Map<String, Object>) readValue(buffer));
        
        default:        
          return super.readValueOfType(type, buffer);
        
      }
    }
    @Override
    protected void writeValue(ByteArrayOutputStream stream, Object value)     {
      if (value instanceof MinewBeaconData) {
        stream.write(128);
        writeValue(stream, ((MinewBeaconData) value).toMap());
      } else 
{
        super.writeValue(stream, value);
      }
    }
  }

  /** Generated interface from Pigeon that represents a handler of messages from Flutter.*/
  public interface Api {
    List<MinewBeaconData> getScannedBeacons();
    void startScan();
    void stopScan();

    /** The codec used by Api. */
    static MessageCodec<Object> getCodec() {
      return ApiCodec.INSTANCE;
    }

    /** Sets up an instance of `Api` to handle messages through the `binaryMessenger`. */
    static void setup(BinaryMessenger binaryMessenger, Api api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.Api.getScannedBeacons", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              List<MinewBeaconData> output = api.getScannedBeacons();
              wrapped.put("result", output);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.Api.startScan", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              api.startScan();
              wrapped.put("result", null);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.Api.stopScan", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              api.stopScan();
              wrapped.put("result", null);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
    }
  }
  private static Map<String, Object> wrapError(Throwable exception) {
    Map<String, Object> errorMap = new HashMap<>();
    errorMap.put("message", exception.toString());
    errorMap.put("code", exception.getClass().getSimpleName());
    errorMap.put("details", null);
    return errorMap;
  }
}
