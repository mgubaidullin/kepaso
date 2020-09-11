package org.kepaso.server;

import java.time.OffsetDateTime;
import java.util.Map;

public class CloudEvent {
    String specversion;
    String type;
    String source;
    String id;
    String time;
    String datacontenttype;
    Map<String, Number> data;

    public CloudEvent() {
    }

    public CloudEvent(String specversion, String type, String source, String id, String time, String datacontenttype, Map<String, Number> data) {
        this.specversion = specversion;
        this.type = type;
        this.source = source;
        this.id = id;
        this.time = time;
        this.datacontenttype = datacontenttype;
        this.data = data;
    }

    public String getSpecversion() {
        return specversion;
    }

    public void setSpecversion(String specversion) {
        this.specversion = specversion;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getDatacontenttype() {
        return datacontenttype;
    }

    public void setDatacontenttype(String datacontenttype) {
        this.datacontenttype = datacontenttype;
    }

    public Map<String, Number> getData() {
        return data;
    }

    public void setData(Map<String, Number> data) {
        this.data = data;
    }

    @Override
    public String toString() {
        return "CloudEvent{" +
                "specversion='" + specversion + '\'' +
                ", type='" + type + '\'' +
                ", source='" + source + '\'' +
                ", id='" + id + '\'' +
                ", time=" + time +
                ", datacontenttype='" + datacontenttype + '\'' +
                ", data=" + data +
                '}';
    }
}
