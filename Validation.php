<?php

/**
*
* This class is for validating user Intcode program inputs
*/
class Validation
{


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


}



?>