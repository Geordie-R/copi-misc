# CGNat Check
Check if your ISP is using CGNat.

## What is CGNAT?
Carrier-Grade NAT (CGNAT) is a system used by internet providers to share a limited number of public IP addresses among many customers. Instead of giving each home a unique public IP address, your ISP assigns a private IP address and places your connection behind a shared public IP.

## Why Does CGNAT Cause Problems for Hosting a Blockchain Node?
When hosting a blockchain node from home, it usually requires incoming connections from other nodes on the internet. If your node needs port 8001 (TCP) open, it means other computers need to be able to directly reach your node on that port.

## Here's the problem with CGNAT:
You don't control the public IP – Since your ISP is sharing it among multiple users, your router isn't actually on the public internet.
No Port Forwarding – Normally, you could configure your router to allow connections on port 8001 and forward them to your node. But with CGNAT, your ISP's system blocks incoming connections before they even reach your router.
Your Node Becomes Invisible – Other blockchain nodes can't reach yours because their connection attempts get stopped at the ISP's CGNAT layer.
# Solution?
To host a blockchain node successfully, you need a way for other devices to connect to you:
Get a real public IP (ask your ISP for a static or dynamic public IP), or, use a VPS from contabo, oneprovider,leaseweb etc

## How do I check for CGNat easily?

### On Ubuntu



### On Windows
