<?php


require_once('Validation.php');
require_once('HaltCodePosition.php');

/**
* This class is to do all calculations
*/
class GravityAssist
{
	use HaltCodePosition;

	private $intCodes;

	/**
	* This position is for the halt code (99)
	* and so cannot be overwritten!
	*/
	private $haltCodePosition;


	/**
	 * @param $intCodes
	 *
	*/
	public function __construct(string $userInput)
	{
		$this->intCodes = $this->removeCharacters($userInput);

		// Get the position of the halt code using HaltCodePosition trait
		$this->haltCodePosition = $this->getHaltCodePosition($this->intCodes, Validation::TERMINATION_CODE);
	}

	

	/**
	*
	* Process the user IntCode Program chunk by chunk
	*/
	public function process()
	{
		// Divide intCode array to chunks of 4
		$chunkOfFour = array_chunk($this->sliceArray(), 4);

		foreach ($chunkOfFour as $key => $chunk) {

			// New values cannot be stored on the position of halt code (99)
			if(isset($chunk[3]) && $chunk[3] != $this->haltCodePosition){
				$this->operate($chunk);
			}
		}
	}

	/**
	* Remove extra characters and just keep numbers
	* @param $intCodes
	* @return array
	*/
	private function removeCharacters(string $userInput): array
	{
		$intCodes = explode(",", $userInput);

		foreach ($intCodes as $key => $value) {
			$intCodes[$key] = preg_replace('/[^0-9]/', '', $value);
		}
		return $intCodes;
	}

	/** 
	* Slice intcode array and eturns all values until haltcode
	* @return array
	*/
	private function sliceArray()
	{
		return array_slice($this->intCodes, 0, $this->haltCodePosition);     
	}

	/**
	* If the results will not be invalid, then
	* add/multiple based on the opcode and set the result
	*
	*@param array $chunk
	*/
	private function operate(array $chunk): void
	{
		$countIntCodes = count($this->intCodes);
		// add
		if ($chunk[0] == 1){
			if ( ($chunk[1] + $chunk[2]) < $countIntCodes){
				$this->intCodes[$chunk[3]] = $chunk[1] + $chunk[2];
			}
		// multiple
		}else {
			if (  ((int)$chunk[1] * (int)$chunk[2] ) < $countIntCodes){
				$this->intCodes[$chunk[3]] = (int)$chunk[1] * (int)$chunk[2];
			}
		}
	}

	/**
	*
	* Print the result
	*@return string
	*/
	public function report(): string
	{
		return json_encode($this->intCodes);
	}


}


?>