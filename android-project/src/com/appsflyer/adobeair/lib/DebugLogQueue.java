package com.appsflyer.adobeair.lib;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by IntelliJ IDEA.
 * User: gil
 * Date: 10/3/12
 * Time: 4:45 PM
 * To change this template use File | Settings | File Templates.
 */
public class DebugLogQueue {
    private static DebugLogQueue ourInstance = new DebugLogQueue();

    List<Item> queue = new ArrayList<Item>();

    public static DebugLogQueue getInstance() {
        return ourInstance;
    }

    private DebugLogQueue() {
    }

    public void push(String msg){
        queue.add(new Item(msg));
    }

    public Item pop(){
        if (queue.size() == 0){
            return null;
        } else {
            Item item = queue.get(0);
            queue.remove(0);
            return item;
        }
    }

    public static class Item {
        private String msg;
        private long timestamp;

        public Item(String msg) {
            this.msg = msg;
            this.timestamp = new Date().getTime();
        }

        public String getMsg() {
            return msg;
        }

        public long getTimestamp() {
            return timestamp;
        }
    }
}
