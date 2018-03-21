package com.jy.webchat.task;

import java.io.File;
import java.util.Calendar;
import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

public class ClearTask /*extends TimerTask*/ {
    private Timer timer;
    private boolean isRunning = false;

    public void run() {
        if (!this.isRunning){
            this.isRunning = true;
            //doTask();
            this.isRunning = false;
        }
    }
    public void start() {
        if (this.timer == null) {
            timer = new Timer(getTaskName());
        }
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.HOUR_OF_DAY, 4); // 凌晨4点
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        Date date = calendar.getTime(); // 第一次执行定时任务的时间
        // 如果第一次执行定时任务的时间 小于当前的时间
        // 此时要在 第一次执行定时任务的时间加一天，以便此任务在下个时间点执行。如果不加一天，任务会立即执行。
        if (date.before(new Date())) {
            date = addDay(date, 1);
        }
        //timer.schedule(this, date, 24 * 60 * 60 * 1000);
    }

    // 增加或减少天数
    public Date addDay(Date date, int num) {
        Calendar startDT = Calendar.getInstance();
        startDT.setTime(date);
        startDT.add(Calendar.DAY_OF_MONTH, num);
        return startDT.getTime();
    }

    public void stop(){
        if (this.timer != null)
            this.timer.cancel();
    }
    protected String getTaskName() {
        return "清除图片";
    }
    private static boolean deleteDir(File dir) {
        if (dir.isDirectory()) {
            String[] children = dir.list();
            //递归删除目录及文件
            for (int i=0; i<children.length; i++) {
                boolean success = deleteDir(new File(dir, children[i]));
                if (!success) {
                    return false;
                }
            }
        }
        // 目录此时为空，可以删除
        return dir.delete();
    }
}
