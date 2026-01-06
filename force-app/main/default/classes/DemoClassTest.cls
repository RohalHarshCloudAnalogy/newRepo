@isTest
private class DemoClassTest {
    @isTest
    static void areaOfCircleTest(){
        Double area = DemoClass.areaOfCircle();
        System.AssertEquals(78.5,area);
    }
    
    @isTest
    static void areaOfTraingleTest(){
        Double area = DemoClass.areaOfTraingle();
        System.AssertEquals(12.0,area);
    }
    
    @isTest
    static void simpleInterest(){
        Double simpleInterest = DemoClass.simpleInterest();
        System.AssertEquals(90.0,simpleInterest);
    }
    
    @isTest
    static void squareCubeTest(){
        List<Integer> ans = DemoClass.squareCube(5);
        System.AssertEquals(25,ans[0]);
        System.AssertEquals(125,ans[1]);
    }
    
    @isTest
    static void swapNumberTest(){
        
        List<Integer> ans = DemoClass.swapNumber(4 , 7);
        System.AssertEquals(7,ans[0]);
        System.AssertEquals(4,ans[1]);
    }
    
    
    
    @isTest
    static void totalAndAvgMarksTest(){
        
        List<Double> answer = DemoClass.totalAndAvgMarks(1,90 ,100, 50);
        System.AssertEquals(240,answer[0]);
        System.AssertEquals(80,answer[1]);
    }
    
    @isTest
    static void checkPosNegZeroTest(){
        
        String pos = DemoClass.checkPosNegZero(100);
        String neg  = DemoClass.checkPosNegZero(-6);
        String zero  = DemoClass.checkPosNegZero(0);
        System.AssertEquals('Positive',pos);
        System.AssertEquals('Negative',neg);
        System.AssertEquals('Zero',zero);
    }
    
	@isTest
	static void findMax(){
        
        Integer maxVal =  DemoClass.findMax(100, 50);
        System.AssertEquals(100,maxVal);
       
    } 
    
    @isTest
	static void numEvenOrOddTest(){
        
        String evenval =  DemoClass.numEvenOrOdd(10);
        String oddval = DemoClass.numEvenOrOdd(7);
        System.AssertEquals('Even',evenval);
        System.AssertEquals('Odd',oddval);
       
    } 
    
    @isTest
    static void giveGradeTest(){
        
        String gradeA =  DemoClass.giveGrade(60,60,60);
        String gradeB =  DemoClass.giveGrade(50,50,50);
        String gradeC =  DemoClass.giveGrade(40,40,40);
        
        System.AssertEquals('Grade A',gradeA);
        System.AssertEquals('Grade B',gradeB);
        System.AssertEquals('Grade C',gradeC);
        
       	
    } 
    
    
    @isTest
    static void examTest(){
		DemoClass.exam();
        List<Account>accList = [Select Id from Account Where Name Like 'Acc%' Limit 101];
        System.Assert(accList.size() ==101 , 'Not Created');
        
    }
    
    @isTest
    static void calculateOnOperatorTest(){
		String addition = DemoClass.calculateOnOperator(10,2,'+');
        String multiply = DemoClass.calculateOnOperator(10,2,'*');
        String substraction = DemoClass.calculateOnOperator(10,2,'-');
        String divide = DemoClass.calculateOnOperator(10,2,'/');
        String otherOperator = DemoClass.calculateOnOperator(10,2,'&');
        
        System.AssertEquals('12',addition);
        System.AssertEquals('20',multiply);
        System.AssertEquals('8',substraction);
        System.AssertEquals('5',divide);
        System.AssertEquals('Invalid Operator',otherOperator);
        
    }
    
    
    
    @isTest
    static void findOddTest(){
		Integer oddN = DemoClass.findOdd(7);
        Integer evenN = DemoClass.findOdd(2);
        System.AssertEquals(2,oddN);
        System.AssertEquals(1,evenN);
        
    }
    
    @isTest
    static void checkFrom10Test(){
        
		String gthan10 = DemoClass.checkFrom10(11);
        String equl10 = DemoClass.checkFrom10(10);
        String lessthan10 = DemoClass.checkFrom10(9);
        
        System.AssertEquals('Greater',gthan10);
        System.AssertEquals('Equal',equl10);
        System.AssertEquals('Less',lessthan10);
        
    }
    
  /*  
    
    @isTest
    static void printAscDescTest(){
        List<List<Integer>>ans = DemoClass.printAscDesc(3,5,1);
        List<Integer>ascending = new List<Integer>();
        ascending.add(1);
        ascending.add(3);
        ascending.add(5);
        List<Integer>descending = new List<Integer>();
        descending.add(5);
        descending.add(3);
        descending.add(1);
        
        System.AssertEquals(ascending,ans[0], 'Incorrect');
        System.AssertEquals(descending,ans[1], 'Incorrect');
    }*/
    
    //17
    @isTest
    static void alternateNumberTest(){
        List<Integer>expected = new List<Integer>();
        List<Integer>ans = DemoClass.alternateNumber();
        for(Integer i=1;i<=99;i+=2){
            expected.add(i);
        }
        System.AssertEquals(expected ,ans );
    }
    
    //25
    //
    @isTest
    static void secondLastDigitTest(){
       Integer ans = DemoClass.secondLastDigit(567);
        System.assertEquals(6,ans);
    }
    
    //34
    @isTest
    static void printTableTest(){
		String ans= '';
        for(Integer i=1;i<=10;i++){
           ans += '5' + '*'+ i +'=' + 5*i;
        }
        String actual = DemoClass.printTable(5);
        System.assertEquals(ans , actual);
    }
    
    
    
    
    
}