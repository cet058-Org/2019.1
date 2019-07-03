%{

/* Código C, use para #include, variáveis globais e constantes
 * este código ser adicionado no início do arquivo fonte em C
 * que será gerado.
 */

#include <stdio.h>
#include <stdlib.h>

typedef struct No {
    int token;
    struct No* direita;
    struct No* esquerda;
} No;


No* allocar_no();
void liberar_no(void* no);
void imprimir_no(No* raiz);
No* novo_no(int, No*, No*);

%}

/* Declaração de Tokens no formato %token NOME_DO_TOKEN */
%union 
{
    int number;
    char *string;
    struct No* no;
}
%token NUM
%token ADD
%token SUB
%token MUL
%token DIV
%token APAR
%token FPAR
%token EOL

%type<no> termo
%type<no> fator
%type<no> exp

%%
/* Regras de Sintaxe */

calc:
    | calc exp EOL       { } 

exp: fator                
   | exp ADD fator       { }
   | exp SUB fator       { }
   ;

fator: termo            
     | fator MUL termo  { }
     | fator DIV termo  { }
     ;

termo: NUM               
     | APAR termo FPAR   { }
     | APAR exp FPAR     { }
     ;

%%

/* Código C geral, será adicionado ao final do código fonte 
 * C gerado.
 */

No* allocar_no() {
    return (No*) malloc(sizeof(No));
}

void liberar_no(void* no) {
    free(no);
}

No* novo_no(int token, No* direita, No* esquerda) {
   No* no = allocar_no();
   no->token = token;
   no->direita = direita;
   no->esquerda = esquerda;

   return no;
}

void imprimir_no(No* raiz) {
    if (raiz->token) {
        printf("CALC");
        return;
    } 
    else {
        imprimir_no(raiz->esquerda);
        printf("%i -- ", raiz->token);
        imprimir_no(raiz->direita);
        return;
    }
}


int main(int argc, char** argv) {
    yyparse();
}

yyerror(char *s) {
    fprintf(stderr, "error: %s\n", s);
}


