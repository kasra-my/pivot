[1mdiff --git a/GravityAssist.php b/GravityAssist.php[m
[1mindex 655a883..b37536d 100644[m
[1m--- a/GravityAssist.php[m
[1m+++ b/GravityAssist.php[m
[36m@@ -7,7 +7,6 @@[m [mrequire_once('HaltCodePosition.php');[m
 /**[m
 * This class is to do all calculations[m
 */[m
[31m-[m
 class GravityAssist[m
 {[m
 	use HaltCodePosition;[m
[36m@@ -51,7 +50,6 @@[m [mclass GravityAssist[m
 				$this->operate($chunk);[m
 			}[m
 		}[m
[31m-		return $this->intCodes;[m
 	}[m
 [m
 	/**[m
[36m@@ -69,6 +67,14 @@[m [mclass GravityAssist[m
 		return $intCodes;[m
 	}[m
 [m
[32m+[m	[32m/**[m[41m [m
[32m+[m	[32m* Slice intcode array and eturns all values until haltcode[m[41m[m
[32m+[m	[32m* @return array[m[41m[m
[32m+[m	[32m*/[m[41m[m
[32m+[m	[32mprivate function sliceArray()[m[41m[m
[32m+[m	[32m{[m[41m[m
[32m+[m		[32mreturn array_slice($this->intCodes, 0, $this->haltCodePosition);[m[41m     [m
[32m+[m	[32m}[m[41m[m
 [m
 	/**[m
 	* If the results will not be invalid, then[m
[36m@@ -92,6 +98,17 @@[m [mclass GravityAssist[m
 		}[m
 	}[m
 [m
[32m+[m	[32m/**[m[41m[m
[32m+[m	[32m*[m[41m[m
[32m+[m	[32m* Print the result[m[41m[m
[32m+[m	[32m*@return string[m[41m[m
[32m+[m	[32m*/[m[41m[m
[32m+[m	[32mpublic function report(): string[m[41m[m
[32m+[m	[32m{[m[41m[m
[32m+[m		[32mreturn json_encode($this->intCodes);[m[41m[m
[32m+[m	[32m}[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
 }[m
 [m
 [m
[1mdiff --git a/Validation.php b/Validation.php[m
[1mindex e5dcf0a..cbff635 100644[m
[1m--- a/Validation.php[m
[1m+++ b/Validation.php[m
[36m@@ -1,214 +1,114 @@[m
 <?php[m
 [m
[32m+[m[41m[m
[32m+[m[32mrequire_once('Validation.php');[m[41m[m
 require_once('HaltCodePosition.php');[m
 [m
 /**[m
[31m-*[m
[31m-* This class is for validating user Intcode program inputs[m
[32m+[m[32m* This class is to do all calculations[m[41m[m
 */[m
[31m-class Validation[m
[32m+[m[32mclass GravityAssist[m[41m[m
 {[m
[31m-[m
 	use HaltCodePosition;[m
 [m
[31m-	public const LIMIT    	        = 100;[m
[31m-	public const TERMINATION_CODE    = 99;[m
[31m-[m
[31m-	private const NOT_INT_ENTRY    			= "Your input is invalid for: ";[m
[31m-	private const INVALID_OP_CODE 			= "Something went wrong. Opcode must be 1, 2 or 99!";[m
[31m-[m
[31m-[m
[31m-	public const INVALID_OPERATTIONS		= "Please notice operations that end of with invalid results are ignored so you will see the same thing as you entered. For example, if the result of add/multiple is greater than the Intcode array count, it will be ignored because that index key is not available! Also, the halt code value (99) will never overwritten!";[m
[31m-[m
[31m-[m
[31m-	// @var string[m
[31m-	private $userInput;[m
[32m+[m	[32mprivate $intCodes;[m[41m[m
 [m
 	/**[m
[31m-	* Intcodes entered by user as an array of integers[m
[31m-	* @var array[m
[32m+[m	[32m* This position is for the halt code (99)[m[41m[m
[32m+[m	[32m* and so cannot be overwritten![m[41m[m
 	*/[m
[31m-	private $intCodes;[m
[32m+[m	[32mprivate $haltCodePosition;[m[41m[m
 [m
 [m
 	/**[m
[31m-	 *  [m
[31m-	 * @param $userInput[m
[32m+[m	[32m * @param $intCodes[m[41m[m
 	 *[m
 	*/[m
 	public function __construct(string $userInput)[m
 	{[m
[31m-		$this->userInput = $userInput;[m
[31m-		$this->intCodes = explode(",", $this->userInput);[m
[32m+[m		[32m$this->intCodes = $this->removeCharacters($userInput);[m[41m[m
[32m+[m[41m[m
[32m+[m		[32m// Get the position of the halt code using HaltCodePosition trait[m[41m[m
[32m+[m		[32m$this->haltCodePosition = $this->getHaltCodePosition($this->intCodes, Validation::TERMINATION_CODE);[m[41m[m
 	}[m
 [m
[32m+[m[41m	[m
 [m
 	/**[m
[31m-	 * Do all validations one by one and if there is something wrong[m
[31m-	 * in each step, break and return the error messages[m
[31m-	 * @return array $errorMsgs[m
[31m-	 */[m
[31m-	public function validate(): array[m
[32m+[m	[32m*[m[41m[m
[32m+[m	[32m* Process the user IntCode Program chunk by chunk[m[41m[m
[32m+[m	[32m*/[m[41m[m
[32m+[m	[32mpublic function process()[m[41m[m
 	{[m
[32m+[m		[32m// Divide intCode array to chunks of 4[m[41m[m
[32m+[m		[32m$chunkOfFour = array_chunk($this->sliceArray(), 4);[m[41m[m
 [m
[31m-		// Validate user inputs to make sure they are integers[m
[31m-		if ( !empty($this->isInteger()) ){[m
[31m-			return $this->isInteger();[m
[31m-		}		[m
[31m-[m
[31m-		// Check whether there is enough intcode (at least 5)[m
[31m-		if ( !empty($this->isThereEnoughIntCode()) ){[m
[31m-			return $this->isThereEnoughIntCode();[m
[31m-		}[m
[31m-[m
[31m-		// Check all numbers are smaller than limit (100)[m
[31m-		if ( !empty($this->isSmallerThanLimit()) ){[m
[31m-			return $this->isSmallerThanLimit();[m
[31m-		}		[m
[31m-[m
[31m-		/**[m
[31m-		* Check termination opcode (99) is available in the[m
[31m-		* user input and it is in the right position. Also checks [m
[31m-		* the opcode is not anything else other than 1 and 2[m
[31m-		*[m
[31m-		*/[m
[31m-		if ( !empty($this->isValidOpcode()) ){[m
[31m-			return $this->isValidOpcode();[m
[31m-		}		[m
[31m-[m
[31m-		/** [m
[31m-		* Checks whether the values of 1st, 2nd and 3rd [m
[31m-		* positions are valid in the given input intcodes array[m
[31m-		*/[m
[31m-		if ( !empty($this->isValidPosition()) ){[m
[31m-			return $this->isValidPosition();[m
[31m-		}			[m
[31m-[m
[31m-		if ( !empty($this->isValidOpcode()) ){[m
[31m-			return $this->isValidOpcode();[m
[31m-		}				[m
[31m-[m
[31m-		return [];[m
[31m-	}[m
[31m-[m
[32m+[m		[32mforeach ($chunkOfFour as $key => $chunk) {[m[41m[m
 [m
[31m-	/** [m
[31m-	* Validate user inputs to make sure they are integers[m
[31m-	* @return array of errors[m
[31m-	*/[m
[31m-	private function isInteger()[m
[31m-	{[m
[31m-		$errorMsgs = [];[m
[31m-		// Are inputs integer?[m
[31m-		foreach ($this->intCodes as $key => $value) {[m
[31m-			if(preg_replace('/[^0-9]/', '', $value) === ""){[m
[31m-				$errorMsgs[] = self::NOT_INT_ENTRY . '"' . $value . '"'; [m
[32m+[m			[32m// New values cannot be stored on the position of halt code (99)[m[41m[m
[32m+[m			[32mif(isset($chunk[3]) && $chunk[3] != $this->haltCodePosition){[m[41m[m
[32m+[m				[32m$this->operate($chunk);[m[41m[m
 			}[m
 		}[m
[31m-[m
[31m-		return $errorMsgs;[m
 	}[m
 [m
 	/**[m
[31m-	* Check whether there is enough intcode [m
[31m-	*  ( > 5in) the user input[m
[32m+[m	[32m* Remove extra characters and just keep numbers[m[41m[m
[32m+[m	[32m* @param $intCodes[m[41m[m
[32m+[m	[32m* @return array[m[41m[m
 	*/[m
[31m-	private function isThereEnoughIntCode()[m
[32m+[m	[32mprivate function removeCharacters(string $userInput): array[m[41m[m
 	{[m
[31m-		$errorMsgs = [];[m
[31m-		if(count($this->intCodes) < 5) {[m
[31m-			$errorMsgs[]	= 'At least 5 numbers needed in your Intcode program entry!';[m
[32m+[m		[32m$intCodes = explode(",", $userInput);[m[41m[m
[32m+[m[41m[m
[32m+[m		[32mforeach ($intCodes as $key => $value) {[m[41m[m
[32m+[m			[32m$intCodes[$key] = preg_replace('/[^0-9]/', '', $value);[m[41m[m
 		}[m
[31m-		return $errorMsgs;[m
[31m-	}	[m
[32m+[m		[32mreturn $intCodes;[m[41m[m
[32m+[m	[32m}[m[41m[m
 [m
[31m-	/**[m
[31m-	* Check all numbers are smaller than limit (100) [m
[32m+[m	[32m/**[m[41m [m
[32m+[m	[32m* Slice intcode array and eturns all values until haltcode[m[41m[m
[32m+[m	[32m* @return array[m[41m[m
 	*/[m
[31m-	private function isSmallerThanLimit()[m
[32m+[m	[32mprivate function sliceArray()[m[41m[m
 	{[m
[31m-		$errorMsgs = [];[m
[31m-		foreach ($this->intCodes as $key => $code) {[m
[31m-			if ($code >= self::LIMIT){[m
[31m-				$errorMsgs[] = $code . ' is greater than "' . self::LIMIT . '"';[m
[31m-			}[m
[31m-		}[m
[31m-		return $errorMsgs;[m
[32m+[m		[32mreturn array_slice($this->intCodes, 0, $this->haltCodePosition);[m[41m     [m
 	}[m
 [m
[31m-[m
 	/**[m
[31m-	* Check termination opcode (99) is available in the[m
[31m-	* user input and it is in the right position. Also checks [m
[31m-	* the opcode is not anything else other than 1 and 2[m
[32m+[m	[32m* If the results will not be invalid, then[m[41m[m
[32m+[m	[32m* add/multiple based on the opcode and set the result[m[41m[m
 	*[m
[32m+[m	[32m*@param array $chunk[m[41m[m
 	*/[m
[31m-	private function isValidOpcode()[m
[32m+[m	[32mprivate function operate(array $chunk): void[m[41m[m
 	{[m
[31m-		$foundHaltCode = false;[m
[31m-		$errorMsgs =[];[m
[31m-[m
[31m-		$chunkOfFour = array_chunk($this->intCodes, 4);[m
[31m-		foreach ($chunkOfFour as $key => $chunk) {[m
[31m-[m
[31m-			if (isset($chunk[0]) && $chunk[0] == self::TERMINATION_CODE){[m
[31m-[m
[31m-				$foundHaltCode = true;[m
[31m-[m
[31m-			}elseif(isset($chunk[0]) && ($chunk[0] != 1 && $chunk[0] != 2)){[m
[31m-[m
[31m-				$errorMsgs[]= 'Your opcode is invalid for: "' . $chunk[0] .'" '. self::INVALID_OP_CODE;[m
[31m-[m
[32m+[m		[32m$countIntCodes = count($this->intCodes);[m[41m[m
[32m+[m		[32m// add[m[41m[m
[32m+[m		[32mif ($chunk[0] == 1){[m[41m[m
[32m+[m			[32mif ( ($chunk[1] + $chunk[2]) < $countIntCodes){[m[41m[m
[32m+[m				[32m$this->intCodes[$chunk[3]] = $chunk[1] + $chunk[2];[m[41m[m
[32m+[m			[32m}[m[41m[m
[32m+[m		[32m// multiple[m[41m[m
[32m+[m		[32m}else {[m[41m[m
[32m+[m			[32mif (  ((int)$chunk[1] * (int)$chunk[2] ) < $countIntCodes){[m[41m[m
[32m+[m				[32m$this->intCodes[$chunk[3]] = (int)$chunk[1] * (int)$chunk[2];[m[41m[m
 			}[m
[31m-[m
[31m-		}[m
[31m-[m
[31m-		if (!$foundHaltCode){[m
[31m-			$errorMsgs[]="Something went wrong! No termination opcode (99) found in the right position!";[m
 		}[m
[31m-		return $errorMsgs;[m
 	}[m
 [m
[31m-[m
 	/**[m
[31m-	* Checks whether the values of 1st, 2nd and 3rd [m
[31m-	* positions are valid in the given input intcodes array[m
[32m+[m	[32m*[m[41m[m
[32m+[m	[32m* Print the result[m[41m[m
[32m+[m	[32m*@return string[m[41m[m
 	*/[m
[31m-	private function isValidPosition()[m
[32m+[m	[32mpublic function report(): string[m[41m[m
 	{[m
[31m-		$countOfIntcodes = count($this->intCodes);[m
[31m-		$errorMsgs =[];[m
[31m-[m
[31m-		$haltCodePosition = $this->getHaltCodePosition($this->intCodes, Validation::TERMINATION_CODE);[m
[31m-		[m
[31m-		// Only the position of intcodes before halt code (99) needs to be validated[m
[31m-		$beforeHaltCode = array_slice($this->intCodes, 0, $haltCodePosition);[m
[31m-[m
[31m-[m
[31m-		$chunkOfFour = array_chunk($beforeHaltCode, 4);[m
[31m-[m
[31m-		foreach ($chunkOfFour as $key => $chunk) {[m
[31m-			if (isset($chunk[1]) && $chunk[1] > $countOfIntcodes){[m
[31m-[m
[31m-				$errorMsgs[] = 'The position of "' . $chunk[1] . '" is not available in your given intcodes!';[m
[31m-[m
[31m-			}[m
[31m-			if ( isset($chunk[2]) && $chunk[2] > $countOfIntcodes){[m
[31m-[m
[31m-				$errorMsgs[] = 'The position of "' . $chunk[2] . '" is not available in your given intcodes!';[m
[31m-[m
[31m-			}[m
[31m-			if (isset($chunk[3]) && $chunk[3] > $countOfIntcodes){[m
[31m-[m
[31m-				$errorMsgs[] = 'The position of "' . $chunk[3] . '" is not available in your given intcodes!';[m
[31m-			}[m
[31m-		}[m
[31m-[m
[31m-		return $errorMsgs;[m
[32m+[m		[32mreturn json_encode($this->intCodes);[m[41m[m
 	}[m
 [m
 [m
[31m-[m
 }[m
 [m
 [m
[1mdiff --git a/index.php b/index.php[m
[1mindex ceb98a9..1620842 100644[m
[1m--- a/index.php[m
[1m+++ b/index.php[m
[36m@@ -50,10 +50,13 @@[m
 					[m
 					if (empty($validationErrors)){[m
 						$gravityAssist = new GravityAssist($userInput);[m
[31m-						var_dump($gravityAssist->process() );[m
[32m+[m						[32m$gravityAssist->process();[m[41m[m
[32m+[m[41m[m
[32m+[m						[32mecho '<div style="background-color:#0CA73A; padding: 5px; font-weight:bold;">' . Validation::INVALID_OPERATTIONS . '</div><br><br>';[m[41m[m
[32m+[m						[32mecho '<div style="color:blue; padding: 5px; font-weight:bold;">The new result is: ' . str_replace('"', "", $gravityAssist->report());[m[41m[m
[32m+[m[41m[m
 [m
 					} else {[m
[31m-						[m
 						// Display all error messages here:[m
 						echo "<ul>";[m
 [m
