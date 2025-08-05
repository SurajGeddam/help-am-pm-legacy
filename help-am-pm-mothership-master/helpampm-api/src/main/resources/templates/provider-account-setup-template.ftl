<html>
    <title></title>
    <head></head>
    <body>
        <div>
             Dear <span th:text="${name}" />!
            <p>
                Thank you for initiating on-boarding process with us.
                As per our record you have not completed your profile yet.
            </p>

            <p>
                Our records shows you have last completed <b><span th:text="${lastCompletedPage}"/>.</b> step on our mobile app .Just few more steps to go.
            </p>

            <p>
                We request you to complete the pending information, so that we can send customer
                requests to you. Unfortunately we will not be able to present you to customers
                until your profile setup is done.
            </p>

             <p>
                We hope will have a wonderful journey together and meet our
                customer's expectations by providing quality services.
             </p>

            <p>Please refer our <a href="${termAndConditionPageUrl}">term and conditions</a>.</p>
        </div>
    </body>
</html>