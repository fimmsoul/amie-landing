document.addEventListener('DOMContentLoaded', () => {
    // Toggle switch functionality
    const toggleSwitch = document.querySelector('input[type="checkbox"]');
    if (toggleSwitch) {
        toggleSwitch.addEventListener('change', function() {
            console.log('Auto-matching is now:', this.checked ? 'enabled' : 'disabled');
        });
    }

    // Go to Chatroom button
    const chatroomButton = document.querySelector('button.w-full');
    if (chatroomButton) {
        chatroomButton.addEventListener('click', () => {
            alert('Going to Chatroom... (This would navigate to the chatroom in a real app)');
        });
    }

    // Sidebar menu items
    const sidebarItems = document.querySelectorAll('.w-44 li');
    sidebarItems.forEach(item => {
        item.addEventListener('click', function() {
            // First, remove the active class from all items
            sidebarItems.forEach(i => {
                i.classList.remove('border-l-4', 'border-pink-200', 'bg-pink-50');
            });
            
            // Then add it to the clicked item
            this.classList.add('border-l-4', 'border-pink-200', 'bg-pink-50');
            
            const menuText = this.textContent.trim();
            console.log(`Clicked on menu item: ${menuText}`);
            
            if (menuText.includes('Log out')) {
                if (confirm('Are you sure you want to log out?')) {
                    alert('You have been logged out. (This would redirect to login in a real app)');
                }
            }
        });
    });

    // Recharge button
    const rechargeButton = document.querySelector('button.ml-2');
    if (rechargeButton) {
        rechargeButton.addEventListener('click', () => {
            alert('Opening recharge options... (This would show payment options in a real app)');
        });
    }

    // Simulate loading the logo image
    const logoImg = document.querySelector('img[alt="Amié"]');
    if (logoImg && !logoImg.src.includes('http')) {
        // Create a text logo as a fallback since we don't have the actual image
        const logoParent = logoImg.parentElement;
        const textLogo = document.createElement('h1');
        textLogo.className = 'logo-text';
        textLogo.textContent = 'Amié';
        logoParent.replaceChild(textLogo, logoImg);
    }
}); 