<?php

/**
*
* This class is for validating user Intcode program inputs
*/
class Validation
{

	public const LIMIT    	        = 100;
	public const TERMINATION_CODE    = 99;

	private const NOT_INT_ENTRY    			= "Your input is invalid for: ";
	private const INVALID_OP_CODE 			= "Something went wrong. Opcode must be 1 or 2!";


	// @var string
	private $userInput;

	/**
	* Intcodes entered by user as an array of integers
	* @var array
	*/
	private $intCodes;



	/**
	 *  
	 * @param $userInput
	 *
	*/
	public function __construct(string $userInput)
	{
		$this->userInput = $userInput;
		$this->intCodes = explode(",", $this->userInput);
	}



	/**
	 * Do all validations one by one and if there is something wrong
	 * in each step, break and return the error messages
	 * @return array $errorMsgs
	 */
	public function validate(): array
	{

		// Validate user inputs to make sure they are integers
		if ( !empty($this->isInteger()) ){
			return $this->isInteger();
		}				


		// Check whether there is enough intcode (at least 5)
		if ( !empty($this->isThereEnoughIntCode()) ){
			return $this->isThereEnoughIntCode();
		}

		// Check all numbers are smaller than limit (100)
		if ( !empty($this->isSmallerThanLimit()) ){
			return $this->isSmallerThanLimit();
		}	


		return [];
	}


	/** 
	* Validate user inputs to make sure they are integers
	* @return array of errors
	*/
	private function isInteger()
	{
		$errorMsgs = [];
		// Are inputs integer?
		foreach ($this->intCodes as $key => $value) {
			if(preg_replace('/[^0-9]/', '', $value) === ""){
				$errorMsgs[] = self::NOT_INT_ENTRY . '"' . $value . '"'; 
			}
		}

		return $errorMsgs;
	}

		/**
	* Check whether there is enough intcode 
	*  ( > 5in) the user input
	*/
	private function isThereEnoughIntCode()
	{
		$errorMsgs = [];
		if(count($this->intCodes) < 5) {
			$errorMsgs[]	= 'At least 5 numbers needed in your Intcode program entry!';
		}
		return $errorMsgs;
	}	

	/**
	* Check all numbers are smaller than limit (100) 
	*/
	private function isSmallerThanLimit()
	{
		$errorMsgs = [];
		foreach ($this->intCodes as $key => $code) {
			if ($code >= self::LIMIT){
				$errorMsgs[] = $code . ' is greater than "' . self::LIMIT . '"';
			}
		}
		return $errorMsgs;
	}

}



?>