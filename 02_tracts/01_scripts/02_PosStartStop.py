#! /opt/python/bin/python2.7
# -*- coding: utf-8 -*-
"""Doc missing
"""

import os
import sys
import glob
import csv
import numpy

"""pwd linux"""

try:
    PATH = sys.argv[1]
except:
    print(__doc__)
    sys.exit(1)


RAW_DATA_EXT_DOM = ".dom.res"

def calculZone(mat, fileP, minV, maxV, midV, TYPE):
    row = len(mat[:,1])
    col = len(mat[1,:])

    """reperage des positons"""
    LL = []
    for j in range(1,col):
        isSup = True
        vPos = []
        vPos.append(int(j))
        for i in range(0,row):
            if(isSup):
                if (float(mat[i,j]) >= float(maxV)):
                    isSup = False
                    vPos.append(int(i))
            else:
                if (float(mat[i,j]) < float(minV)):
                    isSup = True
                    vPos.append(int(i-1))


        if(isSup == False):
            vPos.append(int(row-1))

        LL.append(vPos)

    """affinement des données"""
    LL2 = []
    for vec in LL:
        ps = -1
        ps2 = -1
        size = len(vec)
        if(size>1):
            mi = 0
            """min valeur pour le range a chercher"""
            ma = 0
            """max valeur pour le range a chercher"""

            v2Pos = []
            v2Pos.append(vec[0])

            if(size == 3):
                ma = row
            else:
                """ donc plus de 1 element """
                ma = vec[3]

            for k in range(1,len(vec)):
                """on regarde les positions qu on a trouve"""
                if(k%2==1):
                    """si impair cad la premiere valeur"""
                    find = False
                    for li in range(int(vec[k]),mi,-1):
                        if(float(mat[li,vec[0]]) < midV):
                            find = True
                            ps = li+1
                            mi = vec[k+1]
                            """le min devient la dernière ligne"""
                            break
                            """on a trouve la ligne pour midV"""

                    if(find == False):
                        """cad on a pas trouve de valeur < midV donc"""
                        """ps = vec[k] a def ?"""
                        ps = mi
                        mi = vec[k+1]
                else:
                    """sinon la deuxieme"""
                    find = False
                    """for lli in range(int(vec[k-1]),int(vec[k])): a def ?"""
                    for lli in range(int(vec[k]),int(vec[k-1]),-1):
                        if(float(mat[lli,vec[0]]) >= midV):
                            find = True
                            ps2 = lli
                            if((k+3) < (size-1)):
                                ma = vec[k+3]
                            else:
                                ma = row
                            break

                    if(find == False):
                        ps2 = vec[k]

                    v2Pos.append(int(mat[ps,0]))
                    v2Pos.append(int(mat[ps2,0]))

            LL2.append(v2Pos)
            
  
    fileRes = fileP[0:(len(fileP)-4)]+"._"+str(minV)+"_"+str(maxV)+"_"+ TYPE + "seuil_0.10_res2"  

    with open(fileRes,"w") as fi:
        for val in LL2:
            ligne = ""
            frtElement = str(val[0])
            index = 1
            while(index < (len(val))):
                ligne = ligne + frtElement + " "+str(val[index]) + " " + str(val[index+1]) + "\n"
                index += 2
            fi.write(ligne)
        print("Create file : "+fileRes)


def getListFile(pathDir,pattern):
    return glob.glob(pathDir+"/*"+pattern)

if __name__=="__main__":

  
    print("\n\nDOM")

    files = getListFile(PATH, RAW_DATA_EXT_DOM)
    print(files)

    for f in files:
        result=numpy.array(list(csv.reader(open(f,"rb"),delimiter=' ')))
        calculZone(result, f, 0.10, 0.90, 0.5, "HET")
        calculZone(result, f, 1.10, 1.90, 1.5, "HOM")
        
