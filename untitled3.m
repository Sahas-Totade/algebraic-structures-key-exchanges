%% Algorithmic Cryptography and Key Exchange via Algebraic Groups
% Author: Goldfish Prodigy
% Description: Implements a secure Diffie-Hellman Key Exchange protocol over 
%              finite cyclic groups (Z_p^*), demonstrating modular arithmetic, 
%              primitive roots, and discrete logarithm frameworks.

clear; clc; close all;

%% 1. Cryptographic Group Parameters Setup
% In a real system, 'p' would be a massive prime (e.g., 2048-bit). 
% For this computational prototype, we select a prime manageable by MATLAB precision.
p = 997;  % The modulus: Defines our finite field Z_p
g = 7;    % The generator: A primitive root modulo p that generates the cyclic group

fprintf('=== Algebraic Group Configuration ===\n');
fprintf('Prime Modulus (p): %d\n', p);
fprintf('Group Generator (g): %d (Generates the cyclic group Z_%d^*)\n\n', g, p);

%% 2. Key Generation (Private and Public Multipliers)
% Alice chooses a secret private integer 'a' (element of the set {1, ..., p-1})
private_key_alice = 123; 

% Bob chooses a secret private integer 'b'
private_key_bob = 456; 

% Compute Public Keys: Generator raised to the private power within the finite field
% Algebraic Operation: Public_Key = (g^private_key) mod p
public_key_alice = modular_exponentiation(g, private_key_alice, p);
public_key_bob   = modular_exponentiation(g, private_key_bob, p);

fprintf('=== Public Key Exchange Matrix ===\n');
fprintf('Alice''s Private Choice: %d  ==> Public Broadcast Key (A): %d\n', private_key_alice, public_key_alice);
fprintf('Bob''s Private Choice:   %d  ==> Public Broadcast Key (B): %d\n\n', private_key_bob, public_key_bob);

%% 3. Secret Key Derivation (The Homomorphic Property)
% Alice computes the shared secret using Bob's public key: S_Alice = (B^a) mod p
shared_secret_alice = modular_exponentiation(public_key_bob, private_key_alice, p);

% Bob computes the shared secret using Alice's public key: S_Bob = (A^b) mod p
shared_secret_bob = modular_exponentiation(public_key_alice, private_key_bob, p);

%% 4. Validation and Analysis
fprintf('=== Verification Framework ===\n');
fprintf('Shared Secret computed by Alice: %d\n', shared_secret_alice);
fprintf('Shared Secret computed by Bob:   %d\n', shared_secret_bob);

if shared_secret_alice == shared_secret_bob
    fprintf('SUCCESS: Symmetric cryptographic key successfully established via group homomorphism.\n');
else
    fprintf('FAILURE: Key mismatch. Check algebraic structures.\n');
end

%% 5. Computational Complexity Analysis (Visualizing the Discrete Log Problem)
% To prove why this is secure, we plot the "apparent randomness" of the group elements.
% Finding 'a' given 'g^a mod p' requires checking elements across a scattered field.
powers = 1:100;
group_elements = zeros(size(powers));
for i = 1:length(powers)
    group_elements(i) = modular_exponentiation(g, powers(i), p);
end

figure('Name', 'Discrete Logarithm Hardness Visualization', 'Position', [200, 200, 800, 400]);
plot(powers, group_elements, 'o', 'MarkerEdgeColor', [0.5 0 0.5], 'MarkerFaceColor', [0.7 0.4 0.7]);
grid on;
xlabel('Exponent (Private Key Vector)');
ylabel('Resulting Group Element (Public Key Field)');
title(sprintf('Distribution of elements in Cyclic Group Z_{%d}^* under Generator g=%d', p, g));

%% 6. Local Functions (Right-to-Left Binary Modular Exponentiation)
function result = modular_exponentiation(base, exponent, modulus)
% Efficiently computes (base^exponent) mod modulus without running into 
% arithmetic overflow using a square-and-multiply bitwise approach.

if modulus == 1
    result = 0;
    return;
end

result = 1;
base = mod(base, modulus);

while exponent > 0
    % If exponent is odd, multiply base with result
    if mod(exponent, 2) == 1
        result = mod(result * base, modulus);
    end
    % Exponent must be even now, shift/divide by 2
    exponent = floor(exponent / 2);
    base = mod(base * base, modulus);
end
end