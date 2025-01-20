<div class="sellform">
    <h1 class="sftitle">Book Issue Search Queries</h1>

    <div class="sfcontainer" id="searchQueryCont">
        <form
            class="sform"
            action="include/handleUnissuedBooks.inc.php"
            method="post">
            <input type="submit" value="Books that are not issued" class="sfsubmit" />
        </form>
        <form
            class="sform"
            action="include/handleUnissuedpeople.inc.php"
            method="post">
            <input type="submit" value="Students not issuing a Book" class="sfsubmit" />
        </form>
    </div>
</div>