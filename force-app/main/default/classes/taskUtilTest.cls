@isTest
private class taskUtilTest {
    @isTest
    static void testTaskPriority(){
        String priority = taskUtil.getTaskPriority('NY');
        System.AssertEquals('Normal',priority);
    }
    @isTest
    static void testTaskPrority2(){
         String priority = taskUtil.getTaskPriority('CA');
         System.AssertEquals('High',priority);
    }
    @isTest
    static void testTaskPrority3(){
         String priority = taskUtil.getTaskPriority('NYCA');
         System.AssertEquals(NULL,priority);
    }
}