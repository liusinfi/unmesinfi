package com.jy.webchat.dao;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.*;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.TimeUnit;
@Service(value = "redisParentDao")
public class RedisParentDao {
    /**
     * 日志记录
     */
    private Logger logger = LoggerFactory.getLogger(this.getClass());
    @Autowired
    protected RedisTemplate<String, Object> redisTemplate;
    /**
     * 前缀
     */
    public static final String KEY_PREFIX_VALUE = "ct:value:";
    public static final String KEY_PREFIX_SET = "ct:set:";
    public static final String KEY_PREFIX_LIST = "ct:list:";
    public static final String KEY_PREFIX_MAP = "ct:map:";

    public boolean containsValueKey(String k) {
        return containsKey(KEY_PREFIX_VALUE + k);
    }
    public boolean containsSetKey(String k) {
        return containsKey(KEY_PREFIX_SET + k);
    }
    public boolean containsListKey(String k) {
        return containsKey(KEY_PREFIX_LIST + k);
    }
    public boolean containsMaptKey(String k) {
        return containsKey(KEY_PREFIX_MAP + k);
    }
    public boolean containsKey(String key) {
        try {
            return redisTemplate.hasKey(key);
        } catch (Throwable t) {
            logger.error("判断缓存存在失败key[" + key + ", error[" + t + "]");
        }
        return false;
    }

    public boolean removeValue(String k) {
        return remove(KEY_PREFIX_VALUE + k);
    }
    public boolean removeSet(String k) {
        return remove(KEY_PREFIX_SET + k);
    }
    public boolean removeList(String k) {
        return remove(KEY_PREFIX_LIST + k);
    }
    public boolean removeMap(String k) {
        return remove(KEY_PREFIX_MAP + k);
    }
    public boolean remove(String key) {
        try {
            redisTemplate.delete(key);
            return true;
        } catch (Throwable t) {
            logger.error("获取缓存失败key[" + key + ", error[" + t + "]");
        }
        return false;
    }

    public boolean cacheValue(String k, String v, long time) {
        String key = KEY_PREFIX_VALUE + k;
        try {
            redisTemplate.multi();
            ValueOperations<String, Object> valueOps =  redisTemplate.opsForValue();
            valueOps.set(key, v);
            if (time > 0) redisTemplate.expire(key, time, TimeUnit.SECONDS);
            return true;
        } catch (Throwable t) {
            logger.error("缓存[" + key + "]失败, value[" + v + "]", t);
        }
        return false;
    }

    public boolean cacheValue(String k, String v) {
        return cacheValue(k, v, -1);
    }

    public String getValue(String k) {
        try {
            ValueOperations<String, Object> valueOps =  redisTemplate.opsForValue();
            return valueOps.get(KEY_PREFIX_VALUE + k)!=null? valueOps.get(KEY_PREFIX_VALUE + k).toString() : "";
        } catch (Throwable t) {
            logger.error("获取缓存失败key[" + KEY_PREFIX_VALUE + k + ", error[" + t + "]");
        }
        return null;
    }


    public boolean cacheSet(String k, Object v, long time) {
        String key = KEY_PREFIX_SET + k;
        try {
            SetOperations<String, Object> valueOps =  redisTemplate.opsForSet();
            valueOps.add(key, v);
            if (time > 0) redisTemplate.expire(key, time, TimeUnit.SECONDS);
            return true;
        } catch (Throwable t) {
            logger.error("缓存[" + key + "]失败, value[" + v + "]", t);
        }
        return false;
    }

    public boolean cacheSet(String k, String v) {
        return cacheSet(k, v, -1);
    }

    public boolean cacheSet(String k, Set<Object> v, long time) {
        String key = KEY_PREFIX_SET + k;
        try {
            SetOperations<String, Object> setOps =  redisTemplate.opsForSet();
            setOps.add(key, v.toArray(new Object[v.size()]));
            if (time > 0) redisTemplate.expire(key, time, TimeUnit.SECONDS);
            return true;
        } catch (Throwable t) {
            logger.error("缓存[" + key + "]失败, value[" + v + "]", t);
        }
        return false;
    }

    public boolean cacheSet(String k, Set<String> v) {
        return cacheSet(k, v, -1);
    }

    public Set<Object> getSet(String k) {
        try {
            SetOperations<String, Object> setOps = redisTemplate.opsForSet();
            return setOps.members(KEY_PREFIX_SET + k);
        } catch (Throwable t) {
            logger.error("获取set缓存失败key[" + KEY_PREFIX_SET + k + ", error[" + t + "]");
        }
        return null;
    }
    public int getSetSize(String k) {
        try {
            SetOperations<String, Object> setOps = redisTemplate.opsForSet();
            return setOps.members(KEY_PREFIX_SET + k).size();
        } catch (Throwable t) {
            logger.error("获取set缓存失败key[" + KEY_PREFIX_SET + k + ", error[" + t + "]");
        }
        return 0;
    }
    public boolean removeSetMember(String k, String m) {
        String key = KEY_PREFIX_SET + k;
        try {
            SetOperations<String, Object> setOps =  redisTemplate.opsForSet();
            setOps.remove(key,m);
            return true;
        } catch (Throwable t) {
            logger.error("删除缓存[" + key + "]失败, value[" + m + "]", t);
        }
        return false;
    }

    public boolean cacheList(String k, String v, long time) {
        String key = KEY_PREFIX_LIST + k;
        try {
            ListOperations<String, Object> listOps =  redisTemplate.opsForList();
            listOps.rightPush(key, v);
            if (time > 0) redisTemplate.expire(key, time, TimeUnit.SECONDS);
            return true;
        } catch (Throwable t) {
            logger.error("缓存[" + key + "]失败, value[" + v + "]", t);
            t.printStackTrace();
        }
        return false;
    }

    public boolean trimList(String k, long start, long end) {
        String key = KEY_PREFIX_LIST + k;
        try {
            ListOperations<String, Object> listOps =  redisTemplate.opsForList();
            if(listOps.size(key) > start) {
                listOps.trim(key, start, end);
            }
            return true;
        } catch (Throwable t) {
            t.printStackTrace();
        }
        return false;
    }

    public boolean cacheList(String k, String v) {
        return cacheList(k, v, -1);
    }

    public <T> boolean cacheList(String k, List<T> v, long time) {
        String key = KEY_PREFIX_LIST + k;
        try {
            ListOperations<String, Object> listOps =  redisTemplate.opsForList();
            long l = listOps.rightPushAll(key, v);
            if (time > 0) redisTemplate.expire(key, time, TimeUnit.SECONDS);
            return true;
        } catch (Throwable t) {
            logger.error("缓存[" + key + "]失败, value[" + v + "]", t);
        }
        return false;
    }
    public <T> boolean cacheListObj(String k, List<T> v, long time) {
        String key = KEY_PREFIX_LIST + k;
        try {
            ListOperations<String, Object> listOps =  redisTemplate.opsForList();
            for(T t : v){
                listOps.rightPush(key, t);
            }
            if (time > 0) redisTemplate.expire(key, time, TimeUnit.SECONDS);
            return true;
        } catch (Throwable t) {
            logger.error("缓存[" + key + "]失败, value[" + v + "]", t);
        }
        return false;
    }
    public <T> boolean cacheListSingle(String k, T v, long time) {
        String key = KEY_PREFIX_LIST + k;
        try {
            ListOperations<String, Object> listOps =  redisTemplate.opsForList();
            listOps.rightPush(key, v);
            if (time > 0) redisTemplate.expire(key, time, TimeUnit.SECONDS);
            return true;
        } catch (Throwable t) {
            logger.error("缓存[" + key + "]失败, value[" + v + "]", t);
        }
        return false;
    }

    public boolean cacheList(String k, List<Object> v) {
        return cacheList(k, v, -1);
    }

    public List<Object> getList(String k, long start, long end) {
        String key = KEY_PREFIX_LIST + k;
        try {
            ListOperations<String, Object> listOps =  redisTemplate.opsForList();
            return listOps.range(key, start, end);
        } catch (Throwable t) {
            logger.error("获取list缓存失败key[" + KEY_PREFIX_LIST + key + ", error[" + t + "]");
        }
        return null;
    }

    public long getListSize(String k) {
        try {
            ListOperations<String, Object> listOps =  redisTemplate.opsForList();
            return listOps.size(KEY_PREFIX_LIST + k);
        } catch (Throwable t) {
            logger.error("获取list长度失败key[" + KEY_PREFIX_LIST + k + "], error[" + t + "]");
        }
        return 0;
    }

    public long getListSize(ListOperations<String, String> listOps, String k) {
        try {
            return listOps.size(KEY_PREFIX_LIST + k);
        } catch (Throwable t) {
            logger.error("获取list长度失败key[" + KEY_PREFIX_LIST + k + "], error[" + t + "]");
        }
        return 0;
    }

    public boolean removeOneOfList(String k) {
        String key = KEY_PREFIX_LIST + k;
        try {
            ListOperations<String, Object> listOps =  redisTemplate.opsForList();
            listOps.leftPop(KEY_PREFIX_LIST + k);
            return true;
        } catch (Throwable t) {
            logger.error("移除list缓存失败key[" + KEY_PREFIX_LIST + k + ", error[" + t + "]");
        }
        return false;
    }

    public <T> HashOperations<String,String,T> setCacheMap(String k, Map<String,T> dataMap,long time){
        String key = KEY_PREFIX_MAP + k;
        HashOperations hashOperations = redisTemplate.opsForHash();
        if(null != dataMap){
            for (Map.Entry<String, T> entry : dataMap.entrySet()) {
                hashOperations.put(key,entry.getKey(),entry.getValue());
            }
            if (time > 0) redisTemplate.expire(key, time, TimeUnit.SECONDS);
        }
        return hashOperations;
    }
    public Map getMap(String k){
        String key = KEY_PREFIX_MAP + k;
        HashOperations hashOperations = redisTemplate.opsForHash();
        return hashOperations.entries(key);
    }

}
