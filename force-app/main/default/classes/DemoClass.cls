public class DemoClass {
    //1
    public static Double areaOfCircle(){
        Final Double PI = 3.14;
        Integer radious = 5;
        return pi*radious*radious;
        
    }
    //2
    public static Double areaOfTraingle(){
        Double height = 4;
        Double breadth = 6;
		return 0.5 * 4 * 6;
        
    }
    //3
    public static Double simpleInterest(){
        Double price = 500;
        Integer timeInYear = 3;
        Double rateOfInterest = 6;
        return (price*rateOfInterest*timeInYear)/100;
        
    }
    //4
    public static List<Integer> squareCube(Integer num){
        List<Integer>sqCube = new List<Integer>();
        sqCube.add(num*num);
        sqCube.add(num*num*num); 
        return sqCube;
    }
	
    //5
    public static List<Integer> swapNumber(Integer num1, Integer num2){
		List<Integer>ans = new List<Integer>();
        num1=num1+num2;
        num2 = num1-num2;
        num1 = num1-num2;
        ans.add(num1);
        ans.add(num2);
        return ans;
        
    }
    //6
    public static List<Double> totalAndAvgMarks(Integer rollNo, Integer marksPhysics, Integer marksBio, Integer marksChemistry){
        List<Double>ans = new List<Double>();
        Double marksSum = marksPhysics+marksBio+marksChemistry;
        Double avgMarks = marksSum/3;
        ans.add(marksSum);
        ans.add(avgMarks);
        return ans;
        
        
    }
    
    //7
    public static String checkPosNegZero(Integer num){
        if(num>0){
            return 'Positive';
        }
        else if(num<0){
            return 'Negative';
        }
        else{
            return 'Zero';
        }
    }
    
    //8
    public static Integer findMax(Integer num1, Integer num2){
        return Math.Max(num1, num2);
    }
    
    //9
    
    public static String numEvenOrOdd(Integer num){
        if(Math.Mod(num,2)==0){
            return 'Even';
        }
        else{
            return 'Odd';
        }
    }
    
    //10
    public static String giveGrade( Integer marksPhysics, Integer marksBio, Integer marksChemistry){
        Integer marksSum = marksPhysics+marksBio+marksChemistry;
        Double avgMarks = marksSum/3;
        
        if(avgMarks>=60){
            return 'Grade A';
        }
        else if(avgMarks>=50){
            return 'Grade B';
        }
        else if(avgMarks>=40){
            return 'Grade C';
        }
        return NULL;
    }
    
    
    
    public static void exam(){
        List<Account>accList= new List<Account>();
        for(Integer i=0;i<101;i++){
            Account acc = new Account();
        	acc.Name = 'Acc'+i;
            accList.add(acc);
        }
        insert accList;
    }
    
    //11
    
    public static String calculateOnOperator(Integer num1, Integer num2, String operator  ){
        switch on operator{
            when '+'{
                return String.valueOf(num1+num2);
            }
            when '-'{
                return String.valueOf( Math.abs(num1-num2));
            }
            when '*'{
                return String.valueOf(num1*num2);
            }
            when '/'{
                return String.valueOf(num1/num2);
            }
            when else{
                return 'Invalid Operator';
            }
        }
    } 
    //12
    public static Integer findOdd(Integer num){
        if(Math.Mod(num,2)<>0){
            return 2;
        }
        return 1;
    }
    
    //13
    
    public static String checkFrom10(Integer num){
        if(num>10) return 'Greater';
        else if(num == 10) return 'Equal';
        else return 'Less';
    } 
    
    //14    
    
    public static List<List<Integer>> printAscDesc(Integer num1, Integer num2, Integer num3){
        List<Integer> nums = new List<Integer>();
        nums.add(num1);
        nums.add(num2);
        nums.add(num3);
        for(Integer i=0;i<nums.size()-1;i++){
            for(Integer j=0;j<(nums.size()-i-1);j++){
                if(nums[j]>nums[j+1]){
                    Integer temp = nums[i];
                    nums[i]=nums[i+1];
                    nums[i+1]=temp;
                }
            }
        }
        List<List<Integer>> finalList = new List<List<Integer>>();
        finalList.add(nums);
        List<Integer>nums2 = new List<Integer>();
        for(Integer i=nums.size()-1;i>=0;i--){
            nums2.add(nums[i]);
        }
        
        finalList.add(nums2);
        return finalList;
    }
    
    //15  
    
    public static void isEligbleForMarriage(String maritalStatus,  Integer age){
        if(maritalStatus == 'Unmarried' && Age <30){
            System.debug('eligble for marriage ');
        }
        else{
            System.debug('Not eligble for marriage ');
        }
    }
    
    // 16 
    
   public static Integer findEven(Integer num){
        if(Math.Mod(num,2)==0){
            return 2;
        }
        return 1;
    }
    
    //17

    public static List<Integer> alternateNumber(){
        List<Integer>altNums = new List<Integer>();
        for(Integer i=1;i<=99;i+=2){
            altNums.add(i);
        }
        return altNums;
    }
    
    //18  
    
    public static void backwordsNumber(){
        List<Integer> nums = new List<Integer>();
        for(Integer i=100;i>=0;i--){
            nums.add(i);
        }
        System.debug(nums);
    }
    
    //19
    public static void backwordNumberSkipTwoNumber(){
        List<Integer> nums = new List<Integer>();
        for(Integer i=100;i>=0;i-=3){
            nums.add(i);
        }
        System.debug(nums);
    }
    
    //20

    public static void divisibleBy7(){
        List<Integer> num = new List<Integer>();
        for(Integer i=7;i<=100;i+=7){
            num.add(i);
        }
        System.debug(num);
    }
    
    //21
    public static void printNtoOne(Integer num){
        do{
            System.debug(num);
            num--;
        }while(num >=1);
    }
    
    //22

    public static void printOneToN(Integer num){
        while(num>=1){
            System.debug(num--);
        }
    }
    
    //23
    public static void printNEvenNumber(Integer num){
        List<Integer>EvenNumber = new List<Integer>();
        for(Integer i =2;i<=num;i+=2){
            EvenNumber.add(i);
        }
        System.debug(EvenNumber);
    }
    
    //24
    
    public static void findLastDigit(Integer num){
        Integer lastDigit = Math.mod(num,10);
        if(lastDigit < 0){
            System.debug(-1);
        }
        else{
            System.debug(lastDigit);
        }
    }
    
    // 25
    
    public static Integer secondLastDigit(Integer num){
        if(num/10 == 0) return -1;
        Integer i=1;
        Integer secondRemainder;
        while( i< 3){
            secondRemainder = Math.Mod(num, 10);
            num = num/10;
            i++;
        }
        return secondRemainder;
    }
    
    //26

    public static void loginBuilding26(Integer num1, Integer num2){
        Integer lastDigit1 = Math.Mod(num1,10);
        Integer lastDigit2 = Math.Mod(num2,10);
        System.debug(lastDigit1+lastDigit2);
    }
    
    //27

    public static void printOddNumber(Integer num){
        Integer start = 1;
        List<Integer>oddNums = new List<Integer>();
        for(Integer i=1;i<=num;i++){
            oddNums.add(start);
            start+=2;
        }
        System.debug(oddNums);
    }
    
    //28
    
    public static void reverseNumber(Integer num){
        Integer reverseNumber = 0;
        while(num > 0 ){
           reverseNumber = reverseNumber*10 + Math.Mod(num,10);
            num = num/10;
        }
        System.debug(reverseNumber);
    }
    
    // 29

    public static void sumOfDigits(Integer num){
        Integer sofD = 0;
        while(num>0){
            sofD = sofD + Math.Mod(num,10);
            num = num/10;
        }
        System.debug(sofD);
    }
    
    // 30
    
    public static void countDigits(Integer num){
        Integer count  = 0;
        while(num > 0 ){
            
            num = num/10;
            count++;
        }
        System.debug(count);
    }

    //31
    
    public static void palindrome(Integer num){
        Integer reverse = 0;
        Integer cnum = num;
        while(cnum > 0){
            reverse = reverse*10 + Math.Mod(cnum, 10);
            cnum = cnum/10;
        }
        System.debug(reverse);
        if(num == reverse){
            System.debug('Palindrome');
        }
        else{
            System.debug('Not Palinndrome');
        }
    }

    //32

    public static void checkArmstrong(Integer num){
        Integer sum = 0;
        Integer cnum = num;
        while(num>0){
            Integer digit = Math.Mod(num,10);
            sum += (digit*digit*digit);
            num = num/10;
        }
        if(sum == cnum) System.debug('Armstrong');
        else System.debug('No Armstrong');
            
    }
    
    //33
    public static void checkPerfectNumber(Integer num){
        Integer sum =0;
        for(Integer i=1;i<=(num/2);i++){
            if(Math.Mod(num,i) == 0){
                sum += i;
            }
        }
        if(sum == num){
            System.debug('Perfect Number');
        }
        else{
            System.debug('Not a perfect Number');
        }
    }
    
    //34

    public static String printTable(Integer num){
        String ans= '';
        for(Integer i=1;i<=10;i++){
           ans += num + '*'+ i +'=' + num*i;
        }
        return ans;
    }
    
    //35

    public static void sumOfFirstNDigits(Integer num){
        Integer sum =0;
        for(Integer i=1;i<=num;i++){
            sum += i;
        }
        System.debug(sum);
    }
    
    //36
    public static void factorialOfN(Integer num){
        Integer factorial = 1;
        for(Integer i=2;i<=num;i++){
            factorial = factorial*i;
        }
        System.debug(factorial);
    }
    
    //37

    public static void checkPrime(Integer num){
        Boolean prime = false;
        for(Integer i=2;i<=num/2;i++){
            if(Math.Mod(num,i)==0){
                System.debug('Not a prime');
                prime=!prime;
                break;
            }
        }
        if(!prime){
            System.debug('Prime');
        }
    }
    
    //38
    private static Boolean isPrime(Integer num){
        
        for(Integer i=2;i<=num/2;i++){
            if(Math.Mod(num,i)==0){
                return False;
                
            }
        }
        return True;
    }
    
    public static void printPrime(Integer num){
        for(Integer i=2;i<=num;i++){
            if(isPrime(i)){
                System.debug(i);
            }
        }
    }
    
    //38 
    
    private static Boolean isPrime2(Integer num){
        
        for(Integer i=2;i<=num/2;i++){
            if(Math.Mod(num,i)==0){
                return False;
                
            }
        }
        return True;
    }
    
    public static void printPrime2(Integer num){
        Integer sum =0;
        for(Integer i=2;i<=num;i++){
            if(isPrime(i)){
                sum+=i;
            }
        }
        System.debug(sum);
    }

    
    //39

    public static void fibonacci(Integer num){
    	List<Integer>fib = new List<Integer>();
        Integer num1 = 1;
        Integer num2 = 1;
        fib.add(num1);
        fib.add(num2);
        Integer num3=num1+num2;
        while(num3 <=num){
            
            fib.add(num3);
            num1 = num2;
            num2 = num3;
            num3= num1+num2;
        }
        System.debug(fib);
        
    }
    
    //40
    
    private static Decimal findFactorial(Integer newNum){
        Decimal factorial = 1;
        for(Integer i=2;i<=newNum;i++){
            factorial = factorial*i;
        }
        return factorial;
    }
    public static void addNTersm(Integer num){
        Decimal sum = 0;
        for(Integer i=1;i<=num;i++){
            sum += i/findFactorial(i+1);
            
        }
        System.debug(sum.setScale(5));
    }
    
    
    //41

    public static void printNumberInReverse(Integer num){
        String words='';
        while(num > 0 ){
            Integer digit = Math.Mod(num,10);
            num = num/10;
            switch on digit{
                when 0{
                    words += 'ZERO';
                }
                when 1{
                     words += 'ONE';
                }
                when 2{
                     words += 'TWO';
                }
                when 3{
                     words += 'THREE';
                }
                when 4{
                     words += 'FOUR';
                }
                when 5{
                     words += 'FIVE';
                }
                when 6{
                     words += 'SIX';
                }
                when 7{
                     words += 'SEVEN';
                }
                when 8{
                     words += 'EIGHT';
                }
                when 9{
                     words += 'NINE';
                }
                
            }
            words += ' ';
            
        }
        System.debug(words);
    }
    
    //42

    public static void sumIntegerList(){
        List<Integer> nums = new List<Integer>{1,2,3,4,5,6,7,8,9};
        Integer sum =0;
        for(Integer i : nums){
            sum += i;
        }
        System.debug(sum);
    }
	    
    //43

    public static void printMaxMinFromIntegerList(){
        List<Integer> nums = new List<Integer>{4,7,8,56,3,56,7,0,0,7,5,3,1,3,4,5,5,5,66,7,0};
        nums.sort();
        System.debug(nums[0]);
        System.debug(nums[nums.size() -1]);
        
    }
    
    //44
    
	 public static void seprateEvenOdd(){
        List<Integer> nums = new List<Integer>{4,7,8,56,3,56,7,0,0,7,5,3,1,3,4,5,5,5,66,7,0};
        List<Integer>evenNums = new List<Integer>();
        List<Integer>oddNums = new List<Integer>();
         for(Integer i : nums){
             if(Math.Mod(i,2) == 0 ){
                 evenNums.add(i);
             } 
             else{
                 oddNums.add(i);
             }
         }
         System.debug(evenNums);
         System.debug(oddNums);
     }
    
    //45
    public static void printWeekDay(Integer num){
        /*switch on num{
            when 1{
                System.debug('Sunday');
            }
            when 2{
                System.debug('Monday');
            }
            when 3{
                System.debug('Tuesday');
            }
            when 4{
                System.debug('Wednesday');
            }
            when 5{
                System.debug('Thursday');
            }
            when 6{
                System.debug('Friday');
            }
            when 7{
                System.debug('Saturday');
            }
            when else{
                System.debug('Invalid Number');
            }
        }
*/
        
        Map<Integer,String> weekDay = new Map<Integer,String>();
        weekDay.put(1,'Sunday');
        weekDay.put(2,'Monday');
        weekDay.put(3,'Tuesday');
        weekDay.put(4,'Wednesday');
        weekDay.put(5,'Thursday');
        weekDay.put(6,'Friday');
        weekDay.put(7,'Saturday');
        
        if(weekDay.containsKey(num)){
            System.debug(weekDay.get(num));
        }
        else{
            System.debug('Invalid Number');
        }
        
    }
    
    //46

    public static void printSequence(){
        List<Integer>sequence  = new List<Integer>();
        for(Integer i=0;i<=5;i++){
            sequence.add(i*5);
        }
        System.debug(sequence);
    }
    
	//47
    public static void printSeries(Integer num){
        Integer sum = 0;
        for(Integer i=1;i<=num;i++){
            sum+= (i*i);
        }
        System.debug(sum);
    }
    
    //48

    public static void sumSeries(Integer num){
        
        Integer start = 1;
        Integer ans=0;
        while(start <= num){
            Integer sum = 0;
            for(Integer i=1;i<=start;i++){
                sum+=i;
            }
            ans+=sum;
            start++;
        }
        System.debug(ans);
    }
    
    //49
    private static Decimal findFacto(Integer newNum){
        Decimal factorial = 1;
        for(Integer i=2;i<=newNum;i++){
            factorial = factorial*i;
        }
        return factorial;
    }
    public static void loginBuilding49(Integer num){
        Decimal sum = 0;
        for(Integer i=1;i<=num;i++){
            Decimal power = Math.pow(i,i);
            sum += power/findFacto(i);
            
        }
       
        System.debug(sum.setScale(2));

    }
    
    
    //50

    public static void sumEvenOdd(){
        List<Integer> nums = new List<Integer>{1,3,5,1,3,4,2,6,2};
        Integer evenSum = 0;
        Integer oddSum = 0;
        for(Integer i : nums){
             if(Math.Mod(i,2) == 0 ){
                 evenSum+=i;
             } 
             else{
                 oddSum += i;
             }
         }
         System.debug(evenSum);
         System.debug(oddSum);
     }
    
    //51

    public static void printRepeatedNumber(){
        List<Integer> nums = new List<Integer>{1,1,1,2,2,3,3,3,3,4,5,5,6,7,7,7,7,7,7};
        Map<Integer,Integer> findFrequency = new Map<Integer,Integer>();
        for(Integer i : nums){
            if(findFrequency.containsKey(i)){
                findFrequency.put(i, findFrequency.get(i)+1);
            }
            else{
                findFrequency.put(i, 1);
            }
        }
        for(Integer i : findFrequency.keySet()){
            if(findFrequency.get(i)==1){
                findFrequency.remove(i);
            }
        }
        System.debug(findFrequency);
    }
    
    
    //52
    
    public static void incrementElement(){
        List<Integer>nums = new List<Integer>{1,2,3,4,5,6,7,8,9};
        for(Integer i=0;i<nums.size();i++){
            nums[i] = nums[i]+1;
        }
        System.debug(nums);
    }
    
    //53
    public static void encoding(){
        List<Integer>arr = new List<Integer>{4,6,1,8,8,1,4,2};
        arr.sort();
        Integer left = 0;
        Integer right = arr.size()-1;
        while(left<right){
            Integer temp = arr[left];
            arr[left] = arr[right];
            arr[right] = temp;
            left++;
            right--;
        }
        System.debug(arr);
        for(Integer i=0;i<arr.size()-1;i++){
            arr[i] = arr[i]+arr[i+1];
        }
        System.debug(arr);
    }
    
    //54
    private static Boolean isStable(Integer num){
        Map<Integer,Integer>freq = new Map<Integer,Integer>();
        while(num>0){
            Integer lastDigit = Math.Mod(num,10);
            if(freq.containsKey(lastDigit)){
                freq.put(lastDigit, freq.get(lastDigit)+1);
            }
            else{
                freq.put(lastDigit,1);
            }
            num/=10;
        }
        List<Integer> values = new List<Integer>(freq.values());
        for(Integer i=0;i< values.size()-1;i++){
            if(values[i]!=values[i+1]){
                return False;
            }
        }
        return True;
    }

    public static void logicBuilding54(Integer N , List<Integer>nums){
        Integer stableSum=0;
        Integer unstableSum = 0;
        for(Integer i: nums){
            if(isStable(i)){
                stableSum+=i;
                System.debug('stable number'+ i);
            }
            else{
                unstableSum+=i;
                System.debug('unstable number'+ i);

            }
        }
        
        System.debug(Math.abs(stableSum - unstableSum));
        
    }
    
    //55
	
    
    public static void countCarry(Integer num1, Integer num2){
        Integer carryCount = 0;
        Integer carryDigit=0;
        Integer lastDigitNum1=0;
        Integer lastDigitNum2=0;
        
        // reverse the array by two pointer approatch
        while(num1 >0 && num2 >0){
            lastDigitNum1 = Math.Mod(num1,10);
            lastDigitNum2 = Math.Mod(num2,10);
            Integer addDigit = lastDigitNum1+lastDigitNum2+carryDigit;
            
            if(addDigit /10 != 0 ){
                carryDigit = addDigit/10;
                carryCount++;
            }
            num1/=10;
            num2/=10;
        }
        
        
        while(num1>0){
            lastDigitNum1 = Math.Mod(num1,10);
            //lastDigitNum2 = Math.Mod(num2,10);
            Integer addDigit = lastDigitNum1+carryDigit;
            
            if(addDigit /10 != 0){
                carryDigit = addDigit/10;
                carryCount++;
            }
            num1/=10;
        }
        
        while(num2>0){
           // lastDigitNum1 = Math.Mod(num1,10);
            lastDigitNum2 = Math.Mod(num2,10);
            Integer addDigit = lastDigitNum2+carryDigit;
            
            if(addDigit /10 != 0){
                carryDigit = addDigit/10;
                carryCount++;
            }
            num2/=10;
        }
        
        System.debug(carryCount);
        
    }
    
    //56
    private static Boolean paldrome(Integer num){
        Integer reverse = 0;
        Integer cnum = num;
        while(cnum > 0){
            reverse = reverse*10 + Math.Mod(cnum, 10);
            cnum = cnum/10;
        }
        
        if(num == reverse){
            return TRUE;
        }
        else{
            return FALSE;
        }
    }

    
    public static void sumPalindrome(Integer num1, Integer num2){
        if(num1>num2){
            Integer temp = num1;
            num1 = num2;
            num2 = temp;
        }
        Integer sum =0 ;
        for(Integer i=num1; i<=num2;i++){
            if(paldrome(i)){
                sum+=i;
            }
        }
        System.debug(sum);
    }
    
    //57
    public static void generatePassword(Integer K){
        
    }
    

    //58
    
    public static void wordReverser(String str){
        String word = '';
        String finalAnswer='';
        
        System.debug(str.length());
        for(Integer i = 0 ;i<str.length();i++){
            String curChar = str.substring(i,i+1);
            if(curChar==' '){
                word+=word.length();
                finalAnswer = ' '+word +finalAnswer;
                word = '';
            }
            else{
                word+=curChar;
            }
        }
        word+=word.length();
        finalAnswer = word+finalAnswer;
        System.debug(finalAnswer);
    }
    
	//59
    public static void CountDigitOccurences(Integer num, Integer Digit){
        Integer count = 0;
        while(num>0){
            if(Math.Mod(num,10)==Digit){
                count++;
            }
            num = num/10;
        }
		System.debug(count);
    }
    
    //60

    private static Boolean isPrime3(Integer num){
        
        for(Integer i=2;i<=num/2;i++){
            if(Math.Mod(num,i)==0){
                return False;
                
            }
        }
        return True;
    }
    
    public static void PrimeDigit(Integer num){
        while(num>0){
            Integer lastD= Math.Mod(num,10);
            if(isPrime3(lastD)){
                System.debug(lastD);
            }
            num =num/10;
        }
       // integer num = 'a';
    }
    
    
    
    
}