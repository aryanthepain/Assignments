<div class="single_search_result">
    <div
        class="sform">
        <div>
            <div>
                <div class="sflabel">
                    Roll Number:
                </div>
                <div class="sfinput">
                    <?php echo htmlspecialchars($result["roll"]); ?>
                </div>
            </div>
            <div>
                <div class="sflabel">
                    Book ID:
                </div>
                <div class="sfinput">
                    <?php echo htmlspecialchars($result["ID"]); ?>
                </div>
            </div>
            <div>
                <div class="sflabel">
                    Book Name:
                </div>
                <div class="sfinput">
                    <?php echo htmlspecialchars($result["book_name"]); ?>
                </div>
            </div>
        </div>
        <form
            class="sform"
            action="handleReturn.inc.php"
            method="post">
            <input type="hidden" name="tid" value="<?php echo htmlspecialchars($result["tid"]); ?>">
            <input type="submit" value="Return" class="sfsubmit" />
        </form>
    </div>
</div>