// Validiert planets.json — Torwächter fuer das Welten-Verzeichnis.
// Wird von der GitHub Action bei jedem PR/Push gegen planets.json ausgefuehrt.
const fs = require('fs');

const errors = [];
let data;
try {
  data = JSON.parse(fs.readFileSync('planets.json', 'utf8'));
} catch (e) {
  console.error('❌ planets.json ist kein gueltiges JSON: ' + e.message);
  process.exit(1);
}

if (typeof data !== 'object' || !Array.isArray(data.worlds)) {
  errors.push('Wurzel braucht ein "worlds"-Array.');
} else {
  const seenAddr = new Set();
  data.worlds.forEach((w, i) => {
    const at = 'worlds[' + i + ']';
    if (!w || typeof w !== 'object') { errors.push(at + ': muss ein Objekt sein.'); return; }
    if (typeof w.name !== 'string' || !w.name.trim()) errors.push(at + ': "name" (Text) fehlt.');
    if (w.name && w.name.length > 40) errors.push(at + ': "name" ist zu lang (max 40).');
    if (typeof w.author !== 'string' || !w.author.trim()) errors.push(at + ': "author" (Text) fehlt.');
    if (!Number.isInteger(w.seed)) errors.push(at + ': "seed" muss eine ganze Zahl sein.');
    if (typeof w.address !== 'string' || !/^[\w.-]+:\d{2,5}$/.test(w.address)) {
      errors.push(at + ': "address" muss host:port sein (z.B. 1.2.3.4:7777).');
    } else if (seenAddr.has(w.address)) {
      errors.push(at + ': doppelte Adresse "' + w.address + '".');
    } else {
      seenAddr.add(w.address);
    }
  });
  if (data.worlds.length > 5000) errors.push('Zu viele Welten (max 5000).');
}

if (errors.length) {
  console.error('❌ planets.json ungueltig:');
  errors.forEach(e => console.error('   - ' + e));
  process.exit(1);
}
console.log('✅ planets.json gueltig — ' + data.worlds.length + ' Welt(en).');
