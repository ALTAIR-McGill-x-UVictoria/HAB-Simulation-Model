import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import lfilter

# Parameters
sampling_rate = 1  # 1 sample per second
max_time = 1 * 60  # 1 minute in seconds
time_interval = 1  # Time interval between samples (2 seconds)

# Calculate the number of samples
N = max_time // time_interval  # Total samples for 45 minutes at 2-second intervals

# AR model parameters
p = 2  # AR model order (AR(2) in this case)
ar_coeffs = [0.185, -0.84]  #  AR coefficients
sigma_noise = 1  # Standard deviation of the Gaussian white noise

# Generate white noise input (Gaussian noise) for the AR model
white_noise = np.random.normal(0, sigma_noise, N)

# Define the AR model using the filter function (lfilter from scipy)
ar_output = lfilter([1], np.concatenate(([1], -np.array(ar_coeffs))), white_noise)

# Generate the high-frequency (turbulence) component using von Karman spectrum
def von_karman_spectrum(n, f_min, f_max, sampling_rate):
    # Frequency vector
    freqs = np.fft.fftfreq(n, d=1/sampling_rate)
    # Shift frequencies so that zero is in the center
    freqs = np.fft.fftshift(freqs)

    # Calculate the von Karman spectrum (f^-5/3)
    spectrum = np.zeros(n)
    for i, f in enumerate(freqs):
        if np.abs(f) > f_min:
            spectrum[i] = 1 / (np.abs(f)**(5/3))

    # Generate random noise in the frequency domain
    random_phases = np.exp(2j * np.pi * np.random.random(n))
    noise_freq = np.sqrt(spectrum) * random_phases

    # Perform the inverse FFT to obtain the time-domain signal
    noise_time = np.fft.ifft(noise_freq)
    return np.real(noise_time)

# Apply von Karman model to generate high-frequency turbulence
f_min = 0.01  # Minimum frequency for turbulence (Hz)
cutoff_freq = 0.1  # Cutoff frequency for turbulence shaping (Hz)
high_freq_turbulence = von_karman_spectrum(N, f_min, cutoff_freq, sampling_rate)

# Combine the low-frequency and high-frequency components
total_wind_speed = ar_output + high_freq_turbulence

# Time vector for plotting in seconds (every 2 seconds)
time_seconds = np.arange(0, N * time_interval, time_interval)

# Plot the final wind speed with both components
plt.figure(figsize=(10, 6))
plt.plot(time_seconds, total_wind_speed)
plt.title('Generated Mean Wind Speed with von Karman Spectrum High-Frequency Component')
plt.xlabel('Time (s)')
plt.ylabel('Wind Speed (m/s)')
plt.grid(True)
plt.show()
