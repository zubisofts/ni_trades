   
import 'package:form_field_validator/form_field_validator.dart';

class LYDPhoneValidator extends TextFieldValidator {  
  // pass the error text to the super constructor  
  LYDPhoneValidator({String errorText = 'Enter a valid LYD phone number'}) : super(errorText);  
  
  // return false if you want the validator to return error  
  // message when the value is empty.  
  @override  
   bool get ignoreEmptyValues => true;

  @override
  bool isValid(String? value) {
    // return true if the value is valid according the your condition  
	    return hasMatch(r'^((+|00)?218|0?)?(9[0-9]{8})$', value!); 
  }  

	
}  