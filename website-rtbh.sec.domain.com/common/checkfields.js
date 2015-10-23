function formCheckSearchClient(form)
{
        var keywords = form.mypassword.value;

        if(!keywords.match(/^.{6,}$/))
        {
                alert("You have to enter at least 6 chars.");
                form.mypassword.focus();
                return false;
        }
        return true;
}


