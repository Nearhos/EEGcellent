// Navigation functionality
document.addEventListener('DOMContentLoaded', function() {
    const hamburger = document.querySelector('.hamburger');
    const navMenu = document.querySelector('.nav-menu');

    hamburger.addEventListener('click', function() {
        hamburger.classList.toggle('active');
        navMenu.classList.toggle('active');
    });

    // Close mobile menu when clicking on a link
    document.querySelectorAll('.nav-link').forEach(n => n.addEventListener('click', () => {
        hamburger.classList.remove('active');
        navMenu.classList.remove('active');
    }));

    // Smooth scrolling for navigation links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    // Navbar background on scroll
    window.addEventListener('scroll', function() {
        const navbar = document.querySelector('.navbar');
        if (window.scrollY > 50) {
            navbar.style.background = 'rgba(255, 255, 255, 0.98)';
            navbar.style.boxShadow = '0 2px 20px rgba(0, 0, 0, 0.1)';
        } else {
            navbar.style.background = 'rgba(255, 255, 255, 0.95)';
            navbar.style.boxShadow = 'none';
        }
    });

    // Demo functionality
    const sliders = document.querySelectorAll('input[type="range"]');
    const stressValue = document.getElementById('stressValue');
    const stressLabel = document.getElementById('stressLabel');
    const stressProgress = document.getElementById('stressProgress');

    // Update input values display
    sliders.forEach(slider => {
        const valueDisplay = document.getElementById(slider.id + 'Value');
        slider.addEventListener('input', function() {
            valueDisplay.textContent = parseFloat(this.value).toFixed(2);
            updateStressPrediction();
        });
    });

    function updateStressPrediction() {
        // Get all slider values
        const tp9 = parseFloat(document.getElementById('tp9').value);
        const af7 = parseFloat(document.getElementById('af7').value);
        const af8 = parseFloat(document.getElementById('af8').value);
        const tp10 = parseFloat(document.getElementById('tp10').value);
        const frontal = parseFloat(document.getElementById('frontal').value);
        const temporal = parseFloat(document.getElementById('temporal').value);

        // Simple stress calculation (mock algorithm)
        // In a real implementation, this would call your Python model
        const stressScore = calculateStressScore(tp9, af7, af8, tp10, frontal, temporal);
        
        // Update display
        stressValue.textContent = Math.round(stressScore) + '%';
        
        // Update progress circle
        const circumference = 2 * Math.PI * 50; // r=50
        const offset = circumference - (stressScore / 100) * circumference;
        stressProgress.style.strokeDashoffset = offset;
        
        // Update stress label
        if (stressScore < 30) {
            stressLabel.textContent = 'Low Stress';
            stressProgress.style.stroke = '#10b981';
        } else if (stressScore < 70) {
            stressLabel.textContent = 'Moderate Stress';
            stressProgress.style.stroke = '#f59e0b';
        } else {
            stressLabel.textContent = 'High Stress';
            stressProgress.style.stroke = '#ef4444';
        }
    }

    function calculateStressScore(tp9, af7, af8, tp10, frontal, temporal) {
        // Mock stress calculation algorithm
        // This simulates the behavior of your machine learning model
        let score = 0;
        
        // Higher values generally indicate more stress
        score += tp9 * 20;
        score += af7 * 25;
        score += af8 * 20;
        score += tp10 * 22;
        score += frontal * 15;
        score += temporal * 18;
        
        // Normalize to 0-100 range
        score = Math.min(100, Math.max(0, score));
        
        return score;
    }

    // Initialize stress prediction
    updateStressPrediction();

    // Animated stress bar in hero section
    function animateStressBar() {
        const stressFill = document.getElementById('stressFill');
        const stressPercentage = document.getElementById('stressPercentage');
        
        let currentStress = 23;
        const targetStress = 23;
        
        const animate = () => {
            if (currentStress < targetStress) {
                currentStress += 1;
            } else if (currentStress > targetStress) {
                currentStress -= 1;
            }
            
            stressFill.style.width = currentStress + '%';
            stressPercentage.textContent = currentStress + '%';
            
            if (currentStress !== targetStress) {
                requestAnimationFrame(animate);
            }
        };
        
        animate();
    }

    // Start animation when page loads
    setTimeout(animateStressBar, 1000);

    // Intersection Observer for animations
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);

    // Observe elements for animation
    document.querySelectorAll('.problem-card, .feature-card, .solution-text, .device-mockup').forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(30px)';
        el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(el);
    });

    // Contact form handling
    const contactForm = document.querySelector('.contact-form');
    if (contactForm) {
        contactForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Get form data
            const formData = new FormData(this);
            const name = this.querySelector('input[type="text"]').value;
            const email = this.querySelector('input[type="email"]').value;
            const message = this.querySelector('textarea').value;
            
            // Simple validation
            if (!name || !email || !message) {
                alert('Please fill in all fields');
                return;
            }
            
            // Mock form submission
            alert('Thank you for your message! We will get back to you soon.');
            this.reset();
        });
    }

    // Parallax effect for hero section
    window.addEventListener('scroll', function() {
        const scrolled = window.pageYOffset;
        const hero = document.querySelector('.hero');
        const brainWaves = document.querySelector('.brain-waves');
        
        if (hero && brainWaves) {
            const rate = scrolled * -0.5;
            brainWaves.style.transform = `translateY(${rate}px)`;
        }
    });

    // Add loading animation
    window.addEventListener('load', function() {
        document.body.style.opacity = '1';
    });

    // Initialize page
    document.body.style.opacity = '0';
    document.body.style.transition = 'opacity 0.5s ease';
});

// Additional utility functions
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Optimize scroll events
const optimizedScrollHandler = debounce(function() {
    // Scroll-based animations and effects
}, 10);

window.addEventListener('scroll', optimizedScrollHandler); 