package org.kepaso.server;

import io.quarkus.runtime.StartupEvent;
import io.smallrye.mutiny.Multi;
import io.vertx.core.json.JsonObject;
import io.vertx.mutiny.core.eventbus.EventBus;
import io.vertx.mutiny.core.eventbus.Message;
import org.eclipse.microprofile.config.ConfigProvider;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.enterprise.event.Observes;
import javax.inject.Inject;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

@Path("/")
public class KepasoResource {

    private static final Logger LOGGER = LoggerFactory.getLogger(KepasoResource.class.getCanonicalName());
    public static final String NAME = "kepaso";

    @Inject
    EventBus eventBus;

    @POST
    @Path("/events")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public CloudEvent publish(CloudEvent cloudEvent) {
        eventBus.publish(NAME, JsonObject.mapFrom(cloudEvent));
        return cloudEvent;
    }

    @GET
    @Path("/config")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public JsonObject config() {
        Map<String, String> configs = StreamSupport
                .stream(ConfigProvider.getConfig().getPropertyNames().spliterator(), false)
                .filter(name -> name.startsWith(NAME))
                .collect(Collectors.toMap(
                        name -> name,
                        name -> ConfigProvider.getConfig().getValue(name, String.class)));

        Map<String, Map<String,Map>> schema = new HashMap();
        for (Map.Entry<String, String> config : configs.entrySet()) {
            LOGGER.info(config.getKey());
            String first = config.getKey().replaceFirst("kepaso.\"", "");
            String source = first.substring(0, first.indexOf("\".\""));
            String type = first.substring(first.indexOf("\".\"") + 3, first.lastIndexOf("\"."));
            String param = first.substring(first.lastIndexOf("\".") + 2, first.length());
            Map<String,Map> map = schema.containsKey(source) ? schema.get(source) : new HashMap<>();
            map.put(type, Map.of(param, config.getValue()));
            schema.put(source, map);
        }

        return JsonObject.mapFrom(schema);
    }

    @GET
    @Path("/stream")
    @Produces(MediaType.SERVER_SENT_EVENTS)
    public Multi<JsonObject> eventSourcing() {
        LOGGER.info("Start sourcing");
        return eventBus.<JsonObject>consumer(NAME).toMulti().map(Message::body);
    }
}