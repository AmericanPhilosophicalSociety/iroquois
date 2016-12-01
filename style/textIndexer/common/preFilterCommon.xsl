﻿<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
   xmlns:dc="http://purl.org/dc/elements/1.1/"
   xmlns:expand="http://cdlib.org/xtf/expand"
   xmlns:parse="http://cdlib.org/xtf/parse"
   xmlns:xtf="http://cdlib.org/xtf"
   xmlns:saxon="http://saxon.sf.net/"
   xmlns:FileUtils="java:org.cdlib.xtf.xslt.FileUtils"
   xmlns:CharUtils="java:org.cdlib.xtf.xslt.CharUtils"
   extension-element-prefixes="saxon FileUtils"
   exclude-result-prefixes="#all">
   
   <!--
      Copyright (c) 2008, Regents of the University of California
      All rights reserved.
      
      Redistribution and use in source and binary forms, with or without 
      modification, are permitted provided that the following conditions are 
      met:
      
      - Redistributions of source code must retain the above copyright notice, 
      this list of conditions and the following disclaimer.
      - Redistributions in binary form must reproduce the above copyright 
      notice, this list of conditions and the following disclaimer in the 
      documentation and/or other materials provided with the distribution.
      - Neither the name of the University of California nor the names of its
      contributors may be used to endorse or promote products derived from 
      this software without specific prior written permission.
      
      THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
      AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
      IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
      ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
      LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
      CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
      SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
      INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
      CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
      ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
      POSSIBILITY OF SUCH DAMAGE.
   -->
   
   <!-- ====================================================================== -->
   <!-- Templates                                                              -->
   <!-- ====================================================================== -->
   
   <!-- Fetch meta-data from a Dublin Core record, if present -->
   <xsl:template name="get-dc-meta">
      <xsl:variable name="docpath" select="saxon:system-id()"/>
      <xsl:variable name="base" select="replace($docpath, '(.*)\.[^\.]+$', '$1')"/>
      <xsl:variable name="dcpath" select="concat($base, '.dc.xml')"/>
      <xsl:if test="FileUtils:exists($dcpath)">
         <xsl:apply-templates select="document($dcpath)" mode="inmeta"/>
         
         <!-- special field for OAI -->
         <set xtf:meta="true">
            <xsl:value-of select="'public'"/>
         </set>
      </xsl:if>
   </xsl:template>
   
   <!-- Process DC -->
   <xsl:template match="*" mode="inmeta">
      
      <!-- Copy all metadata fields -->
      <xsl:for-each select="*">
         <xsl:choose>
            <xsl:when test="matches(name(),'identifier')">
               <identifier xtf:meta="true" xtf:tokenize="no">
                  <xsl:copy-of select="@*"/>
                  <xsl:value-of select="replace(replace(string(),'^.+/',''),'\.[A-Za-z]+$','')"/>
               </identifier>
            </xsl:when>
            <xsl:otherwise>
               <xsl:element name="{name()}">
                  <xsl:attribute name="xtf:meta" select="'true'"/>
                  <xsl:copy-of select="@*"/>
                  <xsl:value-of select="string()"/>
               </xsl:element>
            </xsl:otherwise>
         </xsl:choose>
         <!-- special fields for OAI -->
         <xsl:choose>
            <xsl:when test="matches(name(),'date')">
               <dateStamp xtf:meta="true" xtf:tokenize="no">
                  <xsl:value-of select="concat(parse:year(string(.)),'-01-01')"/>
               </dateStamp>
            </xsl:when>
            <xsl:when test="matches(name(),'subject')">
               <set xtf:meta="true">
                  <xsl:value-of select="string()"/>
               </set>
            </xsl:when>
         </xsl:choose>
      </xsl:for-each>
      
   </xsl:template>
   
   <!-- Add sort fields to DC meta-data -->
   <xsl:template name="add-fields">
      <xsl:param name="meta"/>
      <xsl:param name="display"/>
      
      <xtf:meta>
         <!-- Copy all the original fields -->
         <xsl:copy-of select="$meta/*"/>
         
         <!-- Add a field to record the document kind -->
         <display xtf:meta="true" xtf:tokenize="no">
            <xsl:value-of select="$display"/>
         </display>
         
         <!-- Parse the date field to create a year (or range of years) -->
         <xsl:apply-templates select="$meta/*:date" mode="year"/>
         
         <!-- Create sort fields -->
         <xsl:apply-templates select="$meta/*:title[1]" mode="sort"/>   
         <xsl:apply-templates select="$meta/*:tribe[1]" mode="sort"/>   
		
         <!-- Create facets -->
         <xsl:apply-templates select="$meta/*:clan" mode="facet"/>
         <xsl:apply-templates select="$meta/*:gender" mode="facet"/>
         <xsl:apply-templates select="$meta/*:tribe" mode="facet"/>
         <xsl:apply-templates select="$meta/*:place" mode="facet"/>
         
         <xsl:apply-templates select="$meta/*:title[1]" mode="browse"/>
         <xsl:apply-templates select="$meta/*:tribe[1]" mode="browse"/>
         <xsl:apply-templates select="$meta/*:clan[1]" mode="browse"/>
         
      </xtf:meta>
   </xsl:template>
   
   <!-- Parse the date to determine the year (or range of years) -->
   <xsl:template match="*:date" mode="year">
      <year xtf:meta="yes">
         <xsl:copy-of select="parse:year(string(.))"/>
      </year>
   </xsl:template>
   
      <!-- Generate sort-title -->
   <xsl:template match="*:title" mode="sort">
      <sort-title xtf:meta="yes" xtf:tokenize="no">
         <xsl:value-of select="parse:title(string(.))"/>
      </sort-title>
   </xsl:template>
   
   <!-- Generate sort-tribe -->
   <xsl:template match="*:tribe" mode="sort">
      <sort-tribe xtf:meta="yes" xtf:tokenize="no">
         <xsl:value-of select="parse:tribe(string(.))"/>
      </sort-tribe>
   </xsl:template>
   
     <!-- Generate facet-place -->
   <xsl:template match="*:place" mode="facet">
      <facet-place>
         <xsl:attribute name="xtf:meta" select="'true'"/>
         <xsl:attribute name="xtf:facet" select="'yes'"/>
         <xsl:value-of select="normalize-unicode(string(.))"/>
      </facet-place>
   </xsl:template>
   
      <!-- Generate facet-clan -->
   <xsl:template match="*:clan" mode="facet">
      <facet-clan>
         <xsl:attribute name="xtf:meta" select="'true'"/>
         <xsl:attribute name="xtf:facet" select="'yes'"/>
         <xsl:value-of select="normalize-unicode(string(.))"/>
      </facet-clan>
   </xsl:template>
   
   <!-- Generate facet-gender -->
   <xsl:template match="*:gender" mode="facet">
      <facet-gender>
         <xsl:attribute name="xtf:meta" select="'true'"/>
         <xsl:attribute name="xtf:facet" select="'yes'"/>
         <xsl:value-of select="normalize-unicode(string(.))"/>
      </facet-gender>
   </xsl:template>
   
      <!-- Generate facet-tribe -->
   <xsl:template match="*:tribe" mode="facet">
      <facet-tribe>
         <xsl:attribute name="xtf:meta" select="'true'"/>
         <xsl:attribute name="xtf:facet" select="'yes'"/>
         <xsl:value-of select="normalize-unicode(string(.))"/>
      </facet-tribe>
   </xsl:template>

      <!-- Generate browse-title -->
   <xsl:template match="*:title" mode="browse">
      <browse-title>
         <xsl:attribute name="xtf:meta" select="'true'"/>
         <xsl:attribute name="xtf:tokenize" select="'no'"/>
         <xsl:value-of select="parse:alpha(parse:title(.))"/>
      </browse-title>
   </xsl:template>
   
   <!-- Generate browse-tribe -->
   <xsl:template match="*:tribe" mode="browse">
      <browse-tribe>
         <xsl:attribute name="xtf:meta" select="'true'"/>
         <xsl:attribute name="xtf:tokenize" select="'no'"/>
         <xsl:value-of select="parse:alpha(parse:tribe(.))"/>
      </browse-tribe>
   </xsl:template>
   
      <!-- Generate browse-clan -->
   <xsl:template match="*:clan" mode="browse">
      <browse-clan>
         <xsl:attribute name="xtf:meta" select="'true'"/>
         <xsl:attribute name="xtf:tokenize" select="'no'"/>
         <xsl:value-of select="parse:alpha(parse:clan(.))"/>
      </browse-clan>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Functions                                                              -->
   <!-- ====================================================================== -->  
   
      <!-- Function to parse normalized titles out of titles -->  
   <xsl:function name="parse:title">  
      <xsl:param name="title"/>
      <!-- Normalize Spaces & Case-->
      <xsl:variable name="lower-title">
         <xsl:value-of select="lower-case(normalize-space($title))"/>
      </xsl:variable>
      <!-- Remove Punctuation -->
      <xsl:variable name="parse-title">
         <xsl:value-of select="replace($lower-title, '[^a-z0-9 ]', '')"/>
      </xsl:variable>
      <xsl:value-of select="$parse-title"/>
   </xsl:function>  
   
   <!-- Function to parse normalized tribes out of tribes -->  
   <xsl:function name="parse:tribe">
      <xsl:param name="tribe"/>
      <!-- Normalize Spaces & Case-->
      <xsl:variable name="lower-tribe">
         <xsl:value-of select="translate(normalize-space($tribe), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
      </xsl:variable>
      <!-- Remove Punctuation -->
      <xsl:variable name="parse-tribe">
         <xsl:value-of select="replace($lower-tribe, '[^a-z0-9 ]', '')"/>
      </xsl:variable>
      <xsl:value-of select="$parse-tribe"/>
   </xsl:function>  
   
   <!-- Function to parse normalized clans out of clan -->  
   <xsl:function name="parse:clan">
      <xsl:param name="clan"/>
      <!-- Normalize Spaces & Case-->
      <xsl:variable name="lower-clan">
         <xsl:value-of select="translate(normalize-space($clan), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
      </xsl:variable>
      <!-- Remove Punctuation -->
      <xsl:variable name="parse-clan">
         <xsl:value-of select="replace($lower-clan, '[^a-z0-9 ]', '')"/>
      </xsl:variable>
      <xsl:value-of select="$parse-clan"/>
   </xsl:function>  
   
   <!-- Function to parse years out of various date formats -->  
   <xsl:function name="parse:year">
      <xsl:param name="date"/>
      
      <xsl:choose>
         
         <!-- Pattern: 1989-12-1 -->
         <xsl:when test="matches($date, '([^0-9]|^)(\d\d\d\d)[^0-9]*[\-/][^0-9]*\d\d?[^0-9]*[\-/][^0-9]*\d\d?([^0-9]|$)')">
            <xsl:analyze-string select="$date" regex="([^0-9]|^)(\d\d\d\d)[^0-9]*[\-/][^0-9]*\d\d?[^0-9]*[\-/][^0-9]*\d\d?([^0-9]|$)">
               <xsl:matching-substring>
                  <xsl:copy-of select="number(regex-group(2))"/>
               </xsl:matching-substring>
            </xsl:analyze-string>
         </xsl:when>
         
         <!-- Pattern: 1980 - 1984 -->
         <xsl:when test="matches($date, '([^0-9]|^)([12]\d\d\d)[^0-9]*-[^0-9]*([12]\d\d\d)([^0-9]|$)')">
            <xsl:analyze-string select="$date" regex="([^0-9]|^)([12]\d\d\d)[^0-9]*-[^0-9]*([12]\d\d\d)([^0-9]|$)">
               <xsl:matching-substring>
                  <xsl:copy-of select="parse:output-range(regex-group(2), regex-group(3))"/>
               </xsl:matching-substring>
            </xsl:analyze-string>
         </xsl:when>
         
         <!-- Pattern: 1980 - 84 -->
         <xsl:when test="matches($date, '([^0-9]|^)([12]\d\d\d)[^0-9]*-[^0-9]*(\d\d)([^0-9]|$)')">
            <xsl:analyze-string select="$date" regex="([^0-9]|^)([12]\d\d\d)[^0-9]*-[^0-9]*(\d\d)([^0-9]|$)">
               <xsl:matching-substring>
                  <xsl:variable name="year1" select="number(regex-group(2))"/>
                  <xsl:variable name="century" select="floor($year1 div 100) * 100"/>
                  <xsl:variable name="pyear2" select="number(regex-group(3))"/>
                  <xsl:variable name="year2" select="$pyear2 + $century"/>
                  <xsl:copy-of select="parse:output-range($year1, $year2)"/>
               </xsl:matching-substring>
            </xsl:analyze-string>
         </xsl:when>
         
         <!-- Pattern: 1-12-89 -->
         <xsl:when test="matches($date, '([^0-9]|^)\d\d?[^0-9]*[\-/][^0-9]*\d\d?[^0-9]*[\-/][^0-9]*(\d\d)([^0-9]|$)')">
            <xsl:analyze-string select="$date" regex="([^0-9]|^)\d\d?[^0-9]*[\-/][^0-9]*\d\d?[^0-9]*[\-/][^0-9]*(\d\d)([^0-9]|$)">
               <xsl:matching-substring>
                  <xsl:copy-of select="number(regex-group(2)) + 1900"/>
               </xsl:matching-substring>
            </xsl:analyze-string>
         </xsl:when>
         
         <!-- Pattern: 19890112 -->
         <xsl:when test="matches($date, '([^0-9]|^)([12]\d\d\d)[01]\d[0123]\d')">
            <xsl:analyze-string select="$date" regex="([^0-9]|^)([12]\d\d\d)[01]\d[0123]\d">
               <xsl:matching-substring>
                  <xsl:copy-of select="number(regex-group(2))"/>
               </xsl:matching-substring>
            </xsl:analyze-string>
         </xsl:when>
         
         <!-- Pattern: 890112 -->
         <xsl:when test="matches($date, '([^0-9]|^)([4-9]\d)[01]\d[0123]\d')">
            <xsl:analyze-string select="$date" regex="([^0-9]|^)(\d\d)[01]\d[0123]\d">
               <xsl:matching-substring>
                  <xsl:copy-of select="number(regex-group(2)) + 1900"/>
               </xsl:matching-substring>
            </xsl:analyze-string>
         </xsl:when>
         
         <!-- Pattern: 011291 -->
         <xsl:when test="matches($date, '([^0-9]|^)[01]\d[0123]\d(\d\d)')">
            <xsl:analyze-string select="$date" regex="([^0-9]|^)[01]\d[0123]\d(\d\d)">
               <xsl:matching-substring>
                  <xsl:copy-of select="number(regex-group(2)) + 1900"/>
               </xsl:matching-substring>
            </xsl:analyze-string>
         </xsl:when>
         
         <!-- Pattern: 1980 -->
         <xsl:when test="matches($date, '([^0-9]|^)([12]\d\d\d)([^0-9]|$)')">
            <xsl:analyze-string select="$date" regex="([^0-9]|^)([12]\d\d\d)([^0-9]|$)">
               <xsl:matching-substring>
                  <xsl:copy-of select="regex-group(2)"/>            
               </xsl:matching-substring>
            </xsl:analyze-string>
         </xsl:when>
         
         <!-- Pattern: any 4 digits starting with 1 or 2 -->
         <xsl:when test="matches($date, '([12]\d\d\d)')">
            <xsl:analyze-string select="$date" regex="([12]\d\d\d)">
               <xsl:matching-substring>
                  <xsl:copy-of select="regex-group(1)"/>            
               </xsl:matching-substring>
            </xsl:analyze-string>
         </xsl:when>
         
      </xsl:choose>
      
   </xsl:function>
   
   <!-- Function to parse year ranges -->
   <xsl:function name="parse:output-range">
      <xsl:param name="year1-in"/>
      <xsl:param name="year2-in"/>
      
      <xsl:variable name="year1" select="number($year1-in)"/>
      <xsl:variable name="year2" select="number($year2-in)"/>
      
      <xsl:choose>
         
         <xsl:when test="$year2 > $year1 and ($year2 - $year1) &lt; 500">
            <xsl:for-each select="(1 to 500)">
               <xsl:if test="$year1 + position() - 1 &lt;= $year2">
                  <xsl:value-of select="$year1 + position() - 1"/>
                  <xsl:value-of select="' '"/>
               </xsl:if>
            </xsl:for-each>
         </xsl:when>
         
         <xsl:otherwise>
            <xsl:value-of select="$year1"/>
            <xsl:value-of select="' '"/>
            <xsl:value-of select="$year2"/>
         </xsl:otherwise>
         
      </xsl:choose>
      
   </xsl:function>
   
   <!-- function to expand date strings -->
   <xsl:function name="expand:date">
      <xsl:param name="date"/>
      
      <xsl:variable name="year" select="replace($date, '[0-9]+/[0-9]+/([0-9]+)', '$1')"/>
      
      <xsl:variable name="month">
         <xsl:choose>
            <xsl:when test="matches($date,'^[0-9]/[0-9]+/[0-9]+')">
               <xsl:value-of select="0"/>
               <xsl:value-of select="replace($date, '^([0-9])/[0-9]+/[0-9]+', '$1')"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="replace($date, '([0-9]+)/[0-9]+/[0-9]+', '$1')"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>  
      
      <xsl:variable name="day">
         <xsl:choose>
            <xsl:when test="matches($date,'[0-9]+/[0-9]/[0-9]+')">
               <xsl:value-of select="0"/>
               <xsl:value-of select="replace($date, '[0-9]+/([0-9])/[0-9]+', '$1')"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="replace($date, '[0-9]+/([0-9]+)/[0-9]+', '$1')"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <xsl:value-of select="concat($year, '::', $month, '::', $day)"/>
      
   </xsl:function>
   
   <!-- function to create alpha browse facets -->
   <xsl:function name="parse:alpha">
      
      <xsl:param name="string"/>
      
      <xsl:variable name="cleanString" select="lower-case(string($string))"/>
      
      <xsl:choose>
         <xsl:when test="matches($cleanString,'^\W*[a-z]')">
            <xsl:value-of select="replace($cleanString,'^\W*([a-z]).*','$1$1')"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="'other'"/>
         </xsl:otherwise>
      </xsl:choose>
      
   </xsl:function>
</xsl:stylesheet>










