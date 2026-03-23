# DNSDumpster API Bash Script

A professional and beautiful bash script for querying the DNSDumpster API to retrieve comprehensive DNS information for any domain.

## 🚀 Features

- **Beautiful Colored Output** - Professional display with colors and organized sections
- **Comprehensive DNS Data** - A, MX, NS, TXT, and CNAME records
- **Detailed Information** - ASN, country, PTR records, and provider details
- **HTTP/HTTPS Banner Information** - Server details, titles, and SSH banners
- **Input Validation** - Domain format validation and error handling
- **JSON Parsing** - Uses jq for structured data parsing with fallback support
- **Professional Tables** - Clean, aligned tables for better readability

## 📋 Prerequisites

- **curl** - For making API requests
- **jq** - For JSON parsing (recommended, but script has fallback)

### Install jq (if not already installed)

**macOS:**
```bash
brew install jq
```

**Ubuntu/Debian:**
```bash
sudo apt-get install jq
```

**CentOS/RHEL:**
```bash
sudo yum install jq
```

## 🛠️ Installation

1. **Clone this repository:**
   ```bash
   git clone https://github.com/PtrckM/scripts/dnsdump
   cd scripts/dnsdump
   
   # Or download the script directly
   wget https://raw.githubusercontent.com/PtrckM/scripts/dnsdump/main/scripts/dnsdump.sh
   ```

2. **Make the script executable:**
   ```bash
   chmod +x scripts/dnsdump.sh
   ```

3. **(Optional) Create a symlink for easier access:**
   ```bash
   sudo ln -s $(pwd)/scripts/dnsdump.sh /usr/local/bin/dnsdump
   ```

## 🎯 Usage

### Basic Usage
```bash
./scripts/dnsdump.sh <domain>
```

### Examples
```bash
# Scan a single domain
./scripts/dnsdump.sh example.com

# Scan a subdomain
./scripts/dnsdump.sh api.example.com

# Scan a complex domain
./scripts/dnsdump.sh mail.google.com
```

## 📊 Output Sections

The script displays DNS information in organized sections:

### 1. **Domain Information**
- Domain name
- Scan timestamp

### 2. **A Records Table**
- Hostnames
- IP addresses
- Geographic locations

### 3. **MX Records Table**
- Mail servers
- IP addresses
- Provider information

### 4. **NS Records Table**
- Nameservers
- IP addresses
- Provider information

### 5. **TXT Records**
- Hostnames
- TXT record values

### 6. **CNAME Records**
- Hostnames
- Target domains

### 7. **Detailed A Record Information**
- Complete ASN details
- Country information
- PTR records
- Provider names

### 8. **HTTP/HTTPS Banner Information**
- HTTPS titles
- Server software
- SSH banners (if available)

## 🎨 Sample Output

```
╔══════════════════════════════════════════════════════════════╗
║                    DNSDumpster Domain Scanner                ║
╚══════════════════════════════════════════════════════════════╝

┌─ Domain Information ──────────────────────────────────────────
│
Domain:     example.com
Scan Time:  2026-03-23 15:26:30
└────────────────────────────────────────────────────

┌─ A Records ──────────────────────────────────────────
│
Host                 IP Address                     Location
-------------------- ------------------------------ --------------------
example.com          93.184.216.34                United States
└────────────────────────────────────────────────────
```

## ⚙️ Configuration

### API Key
The script includes a pre-configured API key for the DNSDumpster API. To use your own API key:

1. Get your API key from [DNSDumpster Developer Portal](https://dnsdumpster.com/developer/)
2. Edit the script and replace the `API_KEY` variable:
   ```bash
   API_KEY="your-api-key-here"
   ```

### Customization
You can customize the colors and output format by modifying the color variables at the top of the script.

## 🔧 Troubleshooting

### Common Issues

1. **Permission Denied**
   ```bash
   chmod +x scripts/dnsdump.sh
   ```

2. **jq not found**
   ```bash
   # Install jq using your package manager
   brew install jq  # macOS
   sudo apt-get install jq  # Ubuntu/Debian
   ```

3. **API Rate Limits**
   - DNSDumpster API has rate limits
   - Wait between requests if you get rate limited
   - Consider upgrading your API plan for higher limits

4. **Invalid Domain Format**
   - Ensure the domain is in valid format (e.g., example.com)
   - Don't include protocol (http://) or paths

### Debug Mode
For debugging, you can modify the script to show raw API responses by commenting out the JSON parsing sections.

## 📝 API Information

This script uses the [DNSDumpster API](https://dnsdumpster.com/developer/) which provides:

- **Comprehensive DNS enumeration**
- **Subdomain discovery**
- **Banner grabbing**
- **Geographic information**
- **ASN details**
- **Provider information**

## 🤝 Contributing

Contributions are welcome! Please feel free to:

1. Fork the repository
2. Create a feature branch
3. Make your changes
42. Submit a pull request to https://github.com/PtrckM/scripts/dnsdump

### Ideas for Contributions

- Additional output formats (JSON, CSV)
- Batch domain scanning
- Integration with other tools
- Additional DNS record types
- Performance optimizations

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

- Use this script responsibly and in accordance with the DNSDumpster API terms of service
- Respect rate limits and usage policies
- Only scan domains you have permission to investigate
- The authors are not responsible for misuse of this tool

## 📞 Support

If you encounter issues:

1. Check the [Troubleshooting](#-troubleshooting) section
2. Verify your internet connection
3. Ensure your API key is valid
4. Open an issue on https://github.com/PtrckM/scripts/dnsdump with details about the problem

## 🙏 Acknowledgments

- [DNSDumpster](https://dnsdumpster.com/) for providing the API service
- [jq](https://stedolan.github.io/jq/) for JSON parsing
- The open-source community for inspiration and tools

