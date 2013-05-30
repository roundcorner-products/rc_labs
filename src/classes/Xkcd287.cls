// One possible Force.com Apex Solution for http://xkcd.com/287/
//
// @author Ian Zepp <ian.zepp@roundcorner.com>

public class Xkcd287 {
    public class Item {
        public Item(Decimal price, Decimal count) {
            this.price = price;
            this.count = count;
        }
        
        public Item(Item item) {
            this.price = item.price;
            this.count = item.count;
        }
        
        public Decimal price;
        public Decimal count;
        public Decimal total {
            get {
                return price * count;
            }
        }
    }
    
    // Dynamic menu
    public Map<String, Item> menu = null;
    
    // List of solutions
    public List<Map<String, Item>> solutionList = null;
    
    // Constructor
    public Xkcd287() {
        menu = new Map<String, Item> {};
        menu.put('Mixed Fruit', new Item(2.15, 0));
        menu.put('French Fries', new Item(2.75, 0));
        menu.put('Side Salad', new Item(3.35, 0));
        menu.put('Hot Wings', new Item(3.55, 0));
        menu.put('Mozzarella Sticks', new Item(4.20, 0));
        menu.put('Sampler Plate', new Item(5.80, 0));
        
        solutionList = new List<Map<String, Item>> {};
    }
    
    public void calculate() {
        // The original XKCD amount
        calculate(15.05); 
    }
    
    // External method with expected total to be passed in
    public void calculate(Decimal expectedTotal) {
        calculate(expectedTotal, new List<String>(menu.keySet()), menu.clone());
        
        // What's the email of the running user?
        String emailAddress = [
            select Email
              from User
             where Id = :UserInfo.getUserId()
             limit 1
        ].Email;
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        // Assign the addresses for the To and CC lists to the mail object.
        mail.setToAddresses(new String[] { emailAddress });
        
        // Specify the name used as the display name.
        mail.setSenderDisplayName('XKCD 287');
        
        // Specify the subject line for your email address.
        mail.setSubject('Solution Report: expected menu total of $' + expectedTotal);
        
        // Build solution test
        String solutionText = '';
        
        for(Map<String, Item> menuSolution : solutionList) {
            solutionText += 'Solution:\n';
            
            for(String itemName : menuSolution.keySet()) {
                Item item = menuSolution.get(itemName);
                
                if (item.count == 0) {
                    continue;
                }
                
                solutionText += '\t';
                solutionText += item.count.intValue();
                solutionText += ' x ';
                solutionText += itemName;
                solutionText += ' @ $';
                solutionText += item.price;
                solutionText += ' each\n';
            }
            
            solutionText += '\n';
        }
        
        if (solutionList.isEmpty()) {
            solutionText += 'There are no solutions!';
        }
        
        // Specify the text content of the email.
        mail.setPlainTextBody(solutionText);
        
        // Send
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    public void calculate(Decimal expectedTotal, String[] searchKeys, Map<String, Item> menuItems) {
        // Nothing to search?
        if (searchKeys.isEmpty()) {
            return;
        }
        
        // Get the first item
        Item item = menuItems.get(searchKeys.remove(0));
        
        // Loop the items
        while(true) {
            // Recalculate the total
            Decimal currentTotal = totalMap(menuItems);
            
            //system.debug('calculate(): ' + item + ', searching ' + searchKeys);
            //system.debug('.. expectedTotal = ' + expectedTotal + ', currentTotal = ' + currentTotal);
            //system.debug('.. menuItems = ' + menuItems);
            
            // Over the amount, exactly the result, or try to calculate again?
            if (currentTotal > expectedTotal) {
                //system.debug('.. exceeds the maximum allowable amount');
                break;
            } 
            
            if (currentTotal == expectedTotal) {
                //system.debug('.. found match!');
                solutionList.add(cloneMap(menuItems));
                break;
            }
            
            // Run it again
            calculate(expectedTotal, searchKeys.clone(), cloneMap(menuItems));
            
            // Bump the current working item count
            item.count++;
        }
    }
    
    public Decimal totalMap(Map<String, Item> menuItems) {
        Decimal currentTotal = 0;
        
        for(String itemName : menuItems.keySet()) {
           currentTotal += menuItems.get(itemName).total;
        }
        
        return currentTotal;
    }
    
    public Map<String, Item> cloneMap(Map<String, Item> menuItems) {
        menuItems = menuItems.clone();
        
        for(String itemName : menuItems.keySet()) {
            menuItems.put(itemName, new Item(menuItems.get(itemName)));
        }
        
        return menuItems;
    }
}