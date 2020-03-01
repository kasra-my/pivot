<?php
   require_once('includes/header.php');
   require_once('Validation.php');
   require_once('GravityAssist.php');

?>
		<div class="container">
		  <div class="row">
		    <div class="col-sm">
		    	<ul>
					<li> Get the user input </li>
					<li> Validate the user input </li>
					<li> If everything is okay, then analyze the commands </li>
					<li> Do the calculation </li>
					<li> Display the results </li>
				</ul>

		    </div>
		  </div>
		</div>


		<div class="container">

				<form action="" method="POST">
				  <div class="form-group">
				  	<div class="col-xs-3">
					    <label for="intcode">Please enter the Intcode program: </label>
						<?php isset($_POST['intcode'])? $placeHolder = $_POST['intcode'] : $placeHolder = 'Enter Intcode Program' ?>
					    <input type="text" class="form-control" name="intcode" id="intcode" placeholder='<?php echo 'Your last input: ' . $placeHolder; ?>'>
					</div>
				  </div>

				  <button type="submit" class="btn btn-primary">Submit</button>
				</form>


		</div>
		<br>
		<br>
		<br>
		<div class="container">
			<?php

				if(isset($_POST['intcode'])){ 
				  	$userInput        = $_POST['intcode']; 

					$validator        = new Validation($userInput);
					$validationErrors = $validator->validate();
					
					if (empty($validationErrors)){
						$gravityAssist = new GravityAssist($userInput);
						var_dump($gravityAssist->process() );

					} else {
						
						// Display all error messages here:
						echo "<ul>";

						foreach ($validationErrors as $key => $error) {
							echo '<li class="list-group-item list-group-item-danger">';
							echo $error;
							echo '</li>';
						}

						echo "</ul>";
					}

				}  

			?>

		</div>









<?php
require_once('includes/footer.php');

?>