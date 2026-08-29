"""Inventario UUID dal catalogo BDAP CKAN."""
from __future__ import annotations
import json, time
from pathlib import Path
import requests

API = "https://bdap-opendata.rgs.mef.gov.it/SpodCkanApi/api/3/action"
GROUP = "63_bilancio-finanziario-dello-stato"
OUT = Path(__file__).parent.parent / "data" / "bdap_inventory.json"

def get_group():
    r = requests.get(f"{API}/group_show?id={GROUP}&include_datasets=true", timeout=30)
    return r.json()["result"]["packages"]

def get_pkg(uuid):
    try:
        r = requests.get(f"{API}/package_show?id={uuid}", timeout=20)
        d = r.json()
        return d["result"] if d.get("success") else None
    except: return None

def csv_url(res):
    for r in res.get("resources", []):
        if r.get("format","").upper()=="CSV" and "datastore/dump" in r.get("url",""):
            return r["url"]
    return None

def main():
    print("Scarico UUID...")
    uuids = get_group()
    print(f"{len(uuids)} UUID trovati")
    inv, lb = [], []
    for i, u in enumerate(uuids):
        if (i+1)%50==0: print(f"  {i+1}/{len(uuids)}")
        r = get_pkg(u)
        if not r: continue
        item = {"uuid":u,"name":r.get("name",""),"title":r.get("title",""),"csv_url":csv_url(r),"tags":[t["name"] for t in r.get("tags",[])]}
        inv.append(item)
        if item["name"].startswith("spd_lbf_spe_dpc_"): lb.append(item)
        time.sleep(1.5)
    OUT.parent.mkdir(parents=True,exist_ok=True)
    json.dump({"total":len(inv),"items":inv},open(OUT,"w"),indent=2,ensure_ascii=False)
    json.dump({"total":len(lb),"items":lb},open(OUT.parent/"bdap_lb_inventory.json","w"),indent=2,ensure_ascii=False)
    print(f"OK: {len(inv)} totali, {len(lb)} LB, salvato in {OUT}")
    for i in lb[:5]: print(f"  {i['name']}: {i['title'][:60]}")

if __name__=="__main__": main()
