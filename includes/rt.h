/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   rt.h                                               :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/06/23 14:54:15 by bmoiroud          #+#    #+#             */
/*   Updated: 2017/11/05 16:11:23 by bmoiroud         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef RT_H
# define RT_H

# include <math.h>
# include <fcntl.h>
# include <errno.h>
# include <stdio.h>
# include "easy_cl.h"
# include "easy_sdl.h"
# include "libft.h"

# define WIN_H			800
# define WIN_W			1200
# define FOV			1.0472

# define EVENT_STOP		0
# define EVENT_IDLE		1
# define EVENT_UPDATE	2

# define ERR_SYS		0
# define ERR_CL			1
# define ERR_SDL		2
# define ERR_USAGE		3

# define COLOR			16711680
# define INTENSITY		100
# define ZOOM			1.1
# define PI				3.141596
# define MAX_BOUNCES	50
# define MAX_RAND		5000
# define OBJS_MAX		50
# define LGTS_MAX		15

# define ROT_SPEED		2.0
# define SPEED_V		1.0
# define SPEED_H		1.0

# define SPHERE			0
# define PLANE			1
# define CONE			2
# define CYLINDER		3

# define CHESSBOARD 	0
# define BRICKS 		1
# define WOOD 			2
# define MARBLE 		3
# define PERLIN 		4

typedef struct		s_color
{
	int				r;
	int				g;
	int				b;
	int				c;		//couleur sous forme d'int = 0xff << 24 | b << 16 | g << 8 | r
}					t_color;

typedef struct		s_equation
{
	double			a;
	double			b;
	double			c;
	double			delta;
}					t_equation;		// pour le calcul des intersections avec les objets

typedef struct		s_vector
{
	double			x;
	double			y;
	double			z;
	uint32_t : 32;
}					t_vector;

typedef struct		s_ray
{
	t_vector		n;			//normale
	t_vector		pos;
	t_vector		dir;
	double			t;			// distance parcourue
	double			dist;		// distance parcourue
	int				id;			// id du truc touché
	int				bounces;	// nombre de rebonds deja fais
}					t_ray;

typedef struct		s_light
{
	t_vector		pos;
	double			intensity;
	uint64_t : 64;
	uint64_t : 64;
	uint64_t : 64;
}					t_light;

typedef struct		s_object
{
	t_vector		pos;
	t_vector		rot;
	t_vector		size;
	t_color			color;
	double			reflect;	// % de reflexion
	double			refract;	// indice de refraction
	double			transp;		// % de transparence
	double			np;			// pertubation de la normale avec un sinus
	int				type;
	int				p_texture;	//id de texture procedurale
	uint64_t : 64;
}					t_object;

typedef struct		s_eye
{
	t_vector		pos;
	t_vector		rot;
	double			fov;
	double			zoom;
	double			aspect;		// rapport hauteur largeur
	uint64_t : 64;
}					t_eye;

typedef struct		s_rt
{
	t_object		objects[OBJS_MAX];
	t_light			lights[LGTS_MAX];
	t_eye			eye;
	t_vector		m[3];		// 3 vecteurs directeurs
	int				nb_obj;
	int				nb_light;
	int				shadows;	//0 = ombres dures 1 = ombres douces
	int				line;		//pour le parser
	int				effects;	// pour desactiver ou non les effets (ombres, reflexion, transparence...)
	uint64_t : 64;
}					t_rt;

typedef struct		s_key
{
	int				w;
	int				s;
	int				d;
	int				a;
	int				space;
	int				lctrl;
	int				q;
	int				e;
}					t_key;

typedef struct		s_data
{
	t_rt			rt;
	t_cl			cl;
	t_sdl			sdl;
	t_key			keys;
	double			rand[MAX_RAND];		// nombres aleatoires pour opencl qui ne peux pas en generer
}					t_data;

int				ft_objectid(char *str);
int				ft_check_color(char *str);
int				ft_valid_color(int color);
int				ft_check_numbers(char *str, int j);
int				ft_get_obj_color(t_rt *rt, double light);
int				sdl_events(t_sdl *sdl, t_key *keys, t_rt *rt);
long			errors(const int err, const char *comment);
double			ft_limits(double nb, double min, double max);
double			ft_vector_len(t_vector v);
void			ft_parse(char *file, t_data *data);
void			ft_init_data(t_data *data);
void			ft_get_size(t_vector *size, int *fd);
void			ft_get_color(t_color *color, int *fd);
void			ft_init_data(t_data *data);
void			ft_init_objects(char *file, t_rt *rt, int o, int l);
void			ft_error(int error);
void			ft_get_coord(t_vector *pos, int *fd);
void			ft_get_size(t_vector *size, int *fd);
void			ft_get_rotation(t_vector *rotation, int *fd);
void			ft_get_intensity(double *intensity, int *fd);
void			ft_get_fov(t_eye *eye, int *fd);
void			*ft_calc(void *param);
void			ft_default_value(t_object *objs, t_rt *rt);
void			ft_check_collisions(t_rt *rt, t_object *objs, t_light *l);
void			ft_rotate_y(t_eye *eye, t_vector *m, int i);
void			ft_rotate_z(t_eye *eye, t_vector *m, int i);
void			ft_calc_dir_vec(t_eye *eye, t_vector *m);
void			ft_translation(t_vector *pos, int *fd);
void			ft_color(t_color *c, int color);
t_vector		ft_new_vector(double x, double y, double z);
t_vector		ft_vector_product(t_vector v1, t_vector v2);
t_vector		ft_add_vector(t_vector v1, t_vector v2);
t_vector		ft_sub_vector(t_vector v1, t_vector v2);
t_vector		ft_norm_vector(t_vector v);
t_vector		ft_scale_vector(t_vector v, double scale);

#endif
