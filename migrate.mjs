import {readFile,readdir} from 'node:fs/promises';
import {Pool} from 'pg';
if(!process.env.DATABASE_URL)throw Error('Define DATABASE_URL antes de migrar.');
const pool=new Pool({connectionString:process.env.DATABASE_URL});const c=await pool.connect();
try{await c.query('CREATE TABLE IF NOT EXISTS schema_migrations (name text PRIMARY KEY, applied_at timestamptz NOT NULL DEFAULT now())');for(const name of(await readdir(new URL('./migrations/',import.meta.url))).filter(n=>n.endsWith('.sql')).sort()){
 if((await c.query('SELECT 1 FROM schema_migrations WHERE name=$1',[name])).rowCount)continue;
 const sql=(await readFile(new URL('./migrations/'+name,import.meta.url),'utf8')).replace(/\bBEGIN;\s*/,'').replace(/COMMIT;\s*$/,'');
 try{await c.query('BEGIN');await c.query(sql);await c.query('INSERT INTO schema_migrations(name) VALUES($1)',[name]);await c.query('COMMIT');console.log('Aplicada:',name)}catch(e){await c.query('ROLLBACK');throw e}
}}finally{c.release();await pool.end()}
