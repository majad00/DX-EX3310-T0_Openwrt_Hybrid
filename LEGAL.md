# Legal Considerations for Zyxel-Matrix Hybrid OS

## The Linux Kernel syscall Exception

The Linux kernel is licensed under GPLv2, but it includes a special "syscall" exception. This exception clearly states that userspace programs that interface with the kernel through "normal system calls" are **not considered derivative works**.

> Source: [OpenSource StackExchange](https://opensource.stackexchange.com/revisions/d7584147-96e4-4321-a5cd-637a1c6cef97/view-source)

## Your Custom Rootfs is Not Bound by GPL

Your custom rootfs—the squashfs image containing BusyBox, your scripts, and other tools—is a collection of **userspace programs**. Because it communicates with the Linux kernel through standard system calls, it is **not bound by the GPL**.

This is the same principle that allows companies like **Zyxel** to include proprietary applications on top of the open-source Linux kernel without violating its license.

> Reference: [Zyxel Manual](https://www.manualowl.com/m/ZyXEL/GS1510-16/Manual/348762?page=183#manual)

## The 2025 SFC vs. Vizio Lawsuit

This question was at the heart of a major **2025 lawsuit** between the Software Freedom Conservancy (SFC) and Vizio.

### Linus Torvalds' Public Comment

Linus Torvalds, the creator of Linux, publicly commented on the case, reinforcing the GPL's scope.

### The Court Ruling

The court ultimately ruled in favor of **Vizio** on the core issue. The judge determined that:

> The GPLv2 only requires the manufacturer to provide the source code for the open-source components they used (like the kernel). It does **not** grant the user an automatic right to modify and reinstall that software on the original hardware, nor does it require the manufacturer to provide the keys to unlock the hardware.

> Source: [ifeng Tech](https://tech.ifeng.com/c/8pOQxwlnfdS?ch=ttsearch)

### Linus Torvalds' Affirmation

Linus Torvalds affirmed this view, stating that:

> The GPLv2's purpose is to ensure the source code is open, not to force manufacturers to allow the installation of modified versions on their devices.

This directly supports the legality of what you're doing: Zyxel is complying with the GPL by providing the source code for the kernel and other GPL components (which you have requested). The final firmware you create by combining that kernel with a modified rootfs does **not** create a new legal obligation to make the combined image open-source.

## Where This Leaves You

Since we are keeping Zyxel's original, unmodified kernel binary, our responsibilities are straightforward:

### 1. We are not creating a "derivative work"

Because you are not modifying the kernel itself, you are **not bound** by the GPL's "copyleft" clause for your rootfs modifications.

### 2. Your rootfs is your own

The squashfs filesystem you build is your own proprietary work (or can be licensed as you wish), as it is a collection of userspace applications.

### 3. The hybrid image is fine

The resulting hybrid firmware file is simply a distribution of the original GPL kernel alongside your separate userspace code. There is **no legal requirement** to open-source your rootfs modifications.

## Summary

| Component | License Status |
|-----------|----------------|
| Linux Kernel (unmodified) | GPLv2 (provided by Zyxel) |
| Rootfs (your custom squashfs) | Your choice (proprietary or open) |
| Combined Hybrid Firmware | No additional GPL obligations |

---

**Disclaimer:** This information is provided for educational purposes and does not constitute legal advice. Consult a qualified attorney for legal guidance specific to your situation.

**Last Updated:** April 2026