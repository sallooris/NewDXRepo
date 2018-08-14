/*
* Class Name   : SGA_AP24_ProcessControllingFields
* Created Date : 31-July-2017
* Created By   : IDC Offshore
* Description  :  1. Util Class to evaluate Dependent Picklist based on Controlling Picklist
*                
**/
public without sharing class SGA_AP24_ProcessControllingFields {

private static final string BLANK = '';
private Static final Integer ZERO=0;
private Static final Integer ONE=1;
private Static final Integer TWO=2;
private Static final Integer SIX=6; 
    
private static final String base64Chars = BLANK +
            'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
            'abcdefghijklmnopqrstuvwxyz' +
            '0123456789+/';

/************************************************************************************
    Method Name : decimalToBinary
    Parameters  : Integer
    Return type : String
    Description : 
    1)Convert a base64 token into a binary/bits representation
    2)Returns the Equivalent Binary String  e.g. 'gAAA' => '100000000000000000000'             
*************************************************************************************/   
public static String base64ToBits(String validFor) {
        String validForBits = BLANK;
        if (String.isEmpty(validFor)){
            validForBits = validForBits;
        }else{
        for (Integer i = ZERO; i < validFor.length(); i++) {
            String thisChar = validFor.mid(i, ONE);
            Integer val = base64Chars.indexOf(thisChar);
            String bits = decimalToBinary(val).leftPad(SIX,BLANK+ZERO);
            validForBits += bits;
        }
       }
        return validForBits;
    }
    
/************************************************************************************
    Method Name : decimalToBinary
    Parameters  : Integer
    Return type : String
    Description : 
    1)Convert decimal to binary representation 
    2)Returns the Equivalent Binary String               
*************************************************************************************/        
private static String decimalToBinary(Integer val) {
  String bits = BLANK;
   while (val > ZERO) {
         Integer remainder = Math.mod(val, TWO);
         val = Integer.valueOf(Math.floor(val / TWO));
         bits = String.valueOf(remainder) + bits;
    }
 return bits;
}

}