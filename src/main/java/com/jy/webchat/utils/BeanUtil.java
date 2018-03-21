package com.jy.webchat.utils;


import java.beans.BeanInfo;
import java.beans.IntrospectionException;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Date;
import java.util.HashMap;

public class BeanUtil {
    /**
     * bean 转化为实体
     * @param bean
     * @return
     */
    public static HashMap<String,Object> beanToMap(Object bean){
        HashMap<String,Object> map = new HashMap<String,Object>();
        if(null == bean){
            return map;
        }
        Class<?> clazz = bean.getClass();
        BeanInfo beanInfo = null;
        try {
            beanInfo = Introspector.getBeanInfo(clazz);
        } catch (IntrospectionException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        PropertyDescriptor[] descriptors = beanInfo.getPropertyDescriptors();
        for(PropertyDescriptor descriptor : descriptors){
            String propertyName = descriptor.getName();
            if(!"class".equals(propertyName)){
                Method method = descriptor.getReadMethod();
                Object result;
                try {
                    result = method.invoke(bean);
                    if(null != result){
                        map.put(propertyName, result);
                    }else{
                        map.put(propertyName, "");
                    }
                } catch (IllegalArgumentException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                } catch (IllegalAccessException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                } catch (InvocationTargetException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
            }
        }

        return map;
    }
    /**
     * map 转化为 bean
     * @param clazz
     * @param map
     * @return
     */
    public static Object mapToBean(Class clazz,HashMap map){
        Object object = null;
        try {
            object = clazz.newInstance();
            BeanInfo beanInfo = Introspector.getBeanInfo(clazz);

            PropertyDescriptor[] descriptors = beanInfo.getPropertyDescriptors();
            for(PropertyDescriptor descriptor : descriptors){
                String propertyName = descriptor.getName();
                if(map.containsKey(propertyName)){
                    Object value = map.get(propertyName);
                    Object[] args = new Object[1];
                    if(propertyName.indexOf("date")>0 && value instanceof  Long){
                        args[0] = new Date(Long.valueOf(value.toString()));
                    }else{
                        args[0] = value;
                    }
                    descriptor.getWriteMethod().invoke(object, args);
                }
            }

        } catch (InstantiationException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }catch (IntrospectionException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }catch (IllegalArgumentException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return object;
    }
}
