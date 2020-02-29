<?php
   require_once('includes/header.php');
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
					    <label for="exampleInputEmail1">Please enter the Intcode program: </label>
					    <input type="text" class="form-control" name="intcode" placeholder='Enter your IntCode'>
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

					var_dump($userInput);
				}  

			?>

		</div>

	<?php
	require_once('includes/footer.php');
	?>			
