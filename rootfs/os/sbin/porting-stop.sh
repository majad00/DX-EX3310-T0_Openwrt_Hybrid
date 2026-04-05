ps | grep hotplug | grep -v "grep" | awk '{print $1}' | xargs kill -9
echo "" > /proc/sys/kernel/hotplug
ps | grep celld | grep -v "grep" | awk '{print $1}' | xargs kill -9
